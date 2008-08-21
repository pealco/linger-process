require("linger-process.rb")

# A new Experiment object takes two arguments:
#   (1) an Array that specifies the names of the experiment(s)
#   (2) a Hash that specifies how the conditions should be expanded

experiment_names = ["principB", "principC"]

# Here, for example, the condition coded as TNN in the raw data is
# expanded out to the factors RC, N, and U. You can specify as many
# conditions and factors as necessary.

factors = { "TNN" => %w(RC N U),
            "TNM" => %w(RC M U),
            "QNN" => %w(HN N U),
            "QMN" => %w(HN M G)}

experiment = Experiment.new(experiment_names, factors, "./data/")

# All processing is done when the object is created. There are two 
# options for outputting the processed data. You can either output
# it to STD_OUT (to check that everything went smoothly), or you can
# save it to a file.

#puts experiment                # to STD_OUT
experiment.to_file("data.txt") # to a file called data.txt