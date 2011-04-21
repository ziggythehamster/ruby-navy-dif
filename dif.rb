# Data Interchange Format (DIF) is an ancient format used by
# spreadsheet programs that are really, really, old.

# License: Ruby

DIF_VERSION = "1.0"

# An error class, for rescuing.
class DifError < StandardError; end

# The
class Dif
	def initialize(ios)
		@data = []
		@header = {}
		@vectors = []
		
		# Get the first line, which is a header
		line = ios.readline.rstrip.upcase
		header = true
		
		while line
			if header
				if line == "DATA"
					header = false
					tup = nil
					ios.readline # skip line after data, "0,0" in my case
					ios.readline # skip the line after 0,0, '""' in my case
				else
					n = ios.readline.rstrip.split(",").collect { |x| x.to_i } # get the vector # and numerical value
					s = ios.readline.strip[1...-1] # get the string value, remove " and ".
					n << s # the array is now vector, num, str
					
					@header[line.downcase.to_sym] ||= [] # initialize to an empty array if needed
					@header[line.downcase.to_sym] << n # so it's an array in an array now
					
					if line.downcase.to_sym == :vectors
						n[1].times { |x| @vectors << "Field#{x}" } # default field names
					elsif line.downcase.to_sym == :label && n[1] == 0
						@vectors[n[0]-1] = n[2] # fill in labels if we get them.
					end
				end
			end
		end
	end
end