class Experiment

  attr_reader :sentences

  def initialize(experiment, factors, data_directory="./data/", columns = [:words, :word_lengths, :word_positions, :regions, :experiment, :subject, :item, :condition, :sentence_number, :list_position, :reading_times, :log_reading_times, :accuracy])
    @experiments = ([experiment] + ["filler"]).flatten
    @factors = factors
    @columns = columns
    
    @sentences = []

    Dir.foreach(data_directory) do |file|
      if file =~ /(\d+)\.dat/
        puts file
        File.open(data_directory + file) do |current_file|
          sentence = Sentence.new
          list_position = 0
          while line = current_file.gets
            columns = line.split
						if @experiments.any? {|exp| columns[1] == exp}
              if columns[4] != "?"
                sentence[:words]         << columns[5]
                sentence[:regions]       << columns[6]
                sentence[:reading_times] << columns[7]
              elsif columns[4] == "?"
                sentence[:subject]        = columns[0]
                sentence[:experiment]     = columns[1]
                sentence[:item]           = columns[2]
                sentence[:condition]      = columns[3]
                sentence[:factors]        = self.factors(sentence[:condition])
                sentence[:accuracy]       = columns[6] 
                sentence[:list_position]  = (list_position += 1)

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
    @factors[condition].nil? ? %w(NA NA NA).join("\t") : @factors[condition].join("\t")
  end

  def to_s
    out = (@columns.map {|column| column.to_s}).join("\t") + "\n" # The header line. Doesn't expand factors.
    @sentences.each do |s|
      s.compute
      s.length.times do |word|
        line = self.output_columns(s, word)
        out << line.join("\t") + "\n"
      end
    end
    
    return out
  end

  def to_file(file)
    File.new(file, "w+").puts self
    puts "Created #{file}"
  end

  protected
  def output_columns(s, word)
    @columns.map {|column| s[column].class == Array ? s[column][word] : s[column]}
  end
    
end

class Sentence
  
  def initialize
    @attributes = {:words             => [],
                   :word_lengths      => nil,
                   :word_positions    => nil,
                   :regions           => [], 
                   :experiment        => nil, 
                   :subject           => nil, 
                   :item              => nil, 
                   :condition         => nil, 
                   :factors           => nil,
                   :sentence_number   => nil,
                   :list_position     => nil, 
                   :reading_times     => [], 
                   :log_reading_times => [], 
                   :accuracy          => nil}
  end
  
  def [](key)
    @attributes[key]
  end
  
  def []=(key, value)
    @attributes[key] = value
  end
  
  def compute
    self.word_lengths
    self.condition
    self.word_positions
    self.regions
    self.log_reading_times
  end
  
  def length
    @attributes[:words].length
  end
  
  protected
  def word_lengths
    @attributes[:word_lengths] = @attributes[:words].map {|word| word.length}
  end

  def condition
    @attributes[:condition] = "NA" if @attributes[:condition] == "-" 
  end

  def word_positions
    @attributes[:word_positions] = (1..@attributes[:words].length).to_a
  end

  def regions
    @attributes[:regions] = @attributes[:regions].map {|region| (region == "-" or region == "NA") ? "NA" : region[0,1]}
  end
  
  def log_reading_times
    @attributes[:log_reading_times] = @attributes[:reading_times].map {|rt| Math::log(rt)}
  end

end