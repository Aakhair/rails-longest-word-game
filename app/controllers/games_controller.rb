class GamesController < ApplicationController
  require "open-uri"
  require "nokogiri"

  def new
    @random = ('a'..'z').to_a.sample(20)
    @time = Time.now
  end

  def score
    @answer = params[:answer]
    @letters = params[:random_token]
    @start_time = DateTime.parse(params[:start_time])
    @end_time = Time.now
    @time = (@end_time - @start_time).round(2)
    @score = 0

    @results = ["sorry its not valid", "congrats!"]

    answer_splitted = @answer.split(//)
    letters_splitted = @letters.split

    validation = answer_splitted.all? { |char| answer_splitted.count(char) <= letters_splitted.count(char) }


    if validation
      url = "https://wagon-dictionary.herokuapp.com/#{@answer}"
      word_serialized = URI.open(url).read
      word = JSON.parse(word_serialized)

      if word["found"]
        @results = @results[1]
        @score = ((word["length"].to_i / @time) * 10).round(2)
      else
        @results = @results[0]
      end

    else
      @results = @results[0]
    end

  end
end
