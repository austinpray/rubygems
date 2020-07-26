# frozen_string_literal: true

require 'did_you_mean/levenshtein'

##
# A collection of text-wrangling methods

module Gem::Text

  ##
  # Remove any non-printable characters and make the text suitable for
  # printing.
  def clean_text(text)
    text.gsub(/[\000-\b\v-\f\016-\037\177]/, ".".freeze)
  end

  def truncate_text(text, description, max_length = 100_000)
    raise ArgumentError, "max_length must be positive" unless max_length > 0
    return text if text.size <= max_length
    "Truncating #{description} to #{max_length.to_s.reverse.gsub(/...(?=.)/,'\&,').reverse} characters:\n" + text[0, max_length]
  end

  ##
  # Wraps +text+ to +wrap+ characters and optionally indents by +indent+
  # characters

  def format_text(text, wrap, indent=0)
    result = []
    work = clean_text(text)

    while work.length > wrap do
      if work =~ /^(.{0,#{wrap}})[ \n]/
        result << $1.rstrip
        work.slice!(0, $&.length)
      else
        result << work.slice!(0, wrap)
      end
    end

    result << work if work.length.nonzero?
    result.join("\n").gsub(/^/, " " * indent)
  end

  def min3(a, b, c) # :nodoc:
    if a < b && a < c
      a
    elsif b < c
      b
    else
      c
    end
  end

  # This code is based directly on the Text gem implementation
  # Returns a value representing the "cost" of transforming str1 into str2
  def levenshtein_distance(str1, str2)
    DidYouMean::Levenshtein.distance(str1, str2)
  end
end
