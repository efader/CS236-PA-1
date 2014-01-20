#Evan Fader

class MovieRating	
	def initialize
		@raw_data = []
		@popularity = {}
		@users = {}
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

	def load_users
		@users = {}
		@raw_data.each do |entry|
			if @users[entry[0]]
				@users[entry[0]][entry[1]] = entry[2]
			else
				@users[entry[0]] = {}
				@users[entry[0]][entry[1]] = entry[2]
			end
		end
	end

	def load_popularities
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

	def users
		return @users
	end

	def similarity(user1, user2)
		# Similarity is determined by adding up the ratings for
		# all movies shared by both users, adjusted for
		# difference in rating
		factor = 0
		@users[user1].each_pair do |movie1, rating1|
			@users[user2].each_pair do |movie2, rating2|
				if movie1 == movie2
					factor += (5 - (rating1-rating2).abs)
				end
			end
		end
		return factor
	end

	def most_similar(user1)
		# Finds the most similar user or users to the given user
		best_fit = 0
		partners = []
		@users.each_pair do |user2, movie|
			if user1 != user2
				this_fit = similarity(user1, user2)
				if this_fit > best_fit
					best_fit = this_fit
					partners = [user2]
				elsif this_fit == best_fit
					partners << user2
				end
			end
		end
		return partners
	end

end

instance = MovieRating.new
instance.load_data
instance.load_popularities
instance.load_users

puts "Most popular movies:"
a = instance.popularity_list
i = 0
a.each do |b|
	if i < 10
		puts b[0]
		i += 1
	end
end

puts "Most unpopular movies:"
i = 0
a.reverse.each do |b|
	if i < 10
		puts b[0]
		i += 1
	end
end

puts "Most similar user(s) to user 1:"
puts instance.most_similar(1).inspect
