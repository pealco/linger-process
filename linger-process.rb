# linger-process.rb by Pedro Alcocer

class Experiment

  attr_reader :sentences

  def initialize(experiment, factors, data_directory="../data/")
    @experiment = ([experiment] + ["filler"]).flatten
    @factors = factors
    @sentences = []

    Dir.foreach(data_directory) do |file|
      if file =~ /(\d+)\.dat/
        File.open(data_directory + file) do |current_file|
          sentence = Sentence.new
          list_position = 0
          while line = current_file.gets
            columns = line.split
						if @experiment.any? {|exp| columns[1] == exp}
              if columns[4] != "?"
                sentence << columns[5]
                sentence.regions = columns[6]
                sentence.reading_times << columns[7]
              elsif columns[4] == "?"
                sentence.subject    = columns[0]
                sentence.experiment = columns[1]
                sentence.item       = columns[2]
                sentence.condition  = columns[3]
                sentence.accuracy   = columns[6]
                list_position += 1
                sentence.list_position = list_position

                @sentences << sentence
                sentence = Sentence.new
              end
            end
          end
        end
      end
    end
  end

  def factors(condition)
    @factors[condition].nil? ? %w(NA NA NA) : @factors[condition]
  end

  def <<(sentence)
    @sentences << sentence
  end

  def to_s
    out = ""
    @sentences.each do |s|
      s.length.times do |word|
        line = self.cols(s,word)
        out << line.join("\t") + "\n"
      end
    end
    return out
  end

  def to_file(file)
    File.new(file, "w+").puts self
  end

  protected
  def cols(s,word)
    [s.subject, s.item, s.condition, factors(s.condition), s.regions[word], 
     s.reading_times[word], s.log_reading_times[word], s.sentence[word], 
     s.word_lengths[word], s.word_positions[word], s.experiment, s.list_position, s.accuracy]
  end

end

class Sentence
	
	attr_reader   :sentence, :regions
  attr_accessor :experiment, :subject, :item, :condition, :sentence_number
  attr_accessor :list_position, :reading_times, :log_reading_times, :accuracy

  def initialize
    @sentence = []
    @word_lengths = []
    @regions = []
    @reading_times = []
    @log_reading_times = []
  end

  def <<(word)
    @sentence << word
    @word_lengths << word.length
  end

  def condition
    @condition == "-" ? "NA" : @condition
  end

  def log_reading_times
    Math::log(@reading_times).to_i
  end

  def word_lengths
    word_lengths = []
    @sentence.each {|word| word_lengths << word.length}
    word_lengths
  end

  def word_positions
    (1..@sentence.length).to_a
  end

  def regions=(region)
    if region == "-" or region == "NA"
      @regions << "NA"
    else
      @regions << region[0,1]
    end
  end

  def log_reading_times
    @reading_times.map {|reading_time| Math::log(reading_time)}
  end

  def length
    @sentence.length
  end

end