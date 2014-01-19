class MovieRating	
	def initialize
		@raw_data = []
		@popularity = {}
	end

	def load_data
		# puts raw data into an array
		@raw_data = []
		File.open('ml-100k/u.data') do |file|
			file.each_line do |line|
				@raw_data << line.split.map(&:to_i)
			end
		end
	end

	def load_popularities()
		# puts popularities into a hash by movie id
		# popularities are determined by combined total ratings on
		# a scale from -2 to 2, figuring that a rating of 1 or 2
		# should detract from a movie's overall popularity
		# 'popularity' suggests favoring movies that have been
		# viewed the most in addition to being well liked, so
		# this system is appropriate
		@popularity = {}
		@raw_data.each do |entry|
			if @popularity[entry[1]]
				@popularity[entry[1]] += entry[2] - 3
			else
				@popularity[entry[1]] = entry[2] - 3
			end
		end
		@popularity = @popularity.sort_by {|movie_id, rating| rating}.reverse
	end

	def popularity(movie_id)
		return @popularity[movie_id]
	end

	def popularity_list
		return @popularity
	end


end

instance = MovieRating.new
instance.load_data
instance.load_popularities
puts instance.popularity_list.inspect