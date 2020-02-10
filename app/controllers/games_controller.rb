require "open-uri"

class GamesController < ApplicationController
  VOWELS = %w(a e i o u)

  def new
    @letters = []
    vowel = []
    5.times do
      @letters << (('a'..'z').to_a - VOWELS).sample
    end
    5.times do
      vowel << VOWELS.sample
    end
    @letters += vowel
    return @letters.shuffle!
  end

  def score
    @answer = params[:word].upcase
    @english_word = english_word?(@answer)
    @letters = params[:letters].split
    @included = included?(@answer, @letters)
  end

  private

  def included?(word, letters)
    @answer.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    response = open(url)
    result = JSON.parse(response.read)
    result['found']
  end
end
