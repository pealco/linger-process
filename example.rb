require("linger-process.rb")

# A new Experiment object takes four arguments:
#   (1) required, Array that specifies the names of the experiment(s)
#   (2) required, Hash that specifies how the conditions should be expanded
#   (3) optional, String that specifies the directory containing the Linger output data, defaults to "../data/"
#   (4) optional, Array of symbols that specifies what columns should be output, defaults to
#           [:words, :word_lengths, :word_positions, :regions, :experiment, :subject, :item, :condition,
#            :sentence_number, :list_position, :reading_times, :log_reading_times, :accuracy]

experiment_names = ["principB", "principC"]

# Here, for example, the condition coded as TNN in the raw data is
# expanded out to the factors RC, N, and U. You can specify as many
# conditions and factors as necessary.

factors = { "TNN" => %w(RC N U),
            "TNM" => %w(RC M U),
            "QNN" => %w(HN N U),
            "QMN" => %w(HN M G)}

directory = "./data/"

columns = [:subject, :item, :condition, :factors, :regions, 
           :reading_times, :log_reading_times, :words, :word_lengths, 
           :word_positions, :experiment, :list_position, :accuracy]

experiment = Experiment.new(experiment_names, factors, directory, columns)

# All processing is done when the object is created. There are two 
# options for outputting the processed data. You can either output
# it to STD_OUT (to check that everything went smoothly), or you can
# save it to a file.

puts experiment                # to STD_OUT
experiment.to_file("data.txt") # to a file called data.txt