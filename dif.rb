# Data Interchange Format (DIF) is an ancient format used by
# spreadsheet programs that are really, really, old.

# License: Ruby

DIF_VERSION = "1.0"

# Error classes, for rescuing.
class DifError < StandardError; end
class DifInvalidSpecialValueError < DifError; end
class DifInvalidNumericTypeError < DifError; end
class DifInvalidIndicatorError < DifError; end

# This class provides DIF reading capabilities.
# A writer would be a good idea, but since I have
# no desire to open anything in VisiCalc, writing
# is not implemented.
#
# Usage: dif = DifReader.new(iostream)
#
# Example:
#
#   dif = nil
#   File.open("blah.dif") do |f|
#     dif = DifReader.new(f)
#   end
class DifReader
	include Enumerable
	
	attr_reader :data
	attr_reader :header
	attr_reader :vectors

	def initialize(ios)
		@data = []
		@header = {}
		@vectors = []
		
		# Get the first line, which is a header
		line = ios.readline.rstrip.upcase
		header = true
		data_line = nil
		
		while line
			if header
				# Process the header lines.
				if line == "DATA"
					# Switch to data mode
					header = false
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
			else
				# Handle the data.
				n = line.split(",").collect { |x| x.to_i }
				s = ios.readline.rstrip
				if n[0] == -1
					# special data values / control codes
					if s.downcase.to_sym == :bot
						# beginning of data/tuple
						@data << data_line if data_line
						data_line = []
					elsif s.downcase.to_sym == :eod
						# end of document
						@data << data_line
						line = nil # breaks out of the loop.
					else
						raise DifInvalidSpecialValueError, "Invalid special data value [#{s}]"
					end
				elsif n[0] == 0
					# numeric values
					if ["V", "TRUE", "FALSE"].include?(s)
						data_line << n[1]
					elsif ["NA", "ERROR"].include?(s)
						data_line << nil
					else
						raise DifInvalidNumericTypeError, "Invalid numeric data type [#{s}]"
					end
				elsif n[0] == 1
					# strings
					s.strip!
					s = s[1...-1] if  s[0] == '"' # remove quotes if needed.
					data_line << s
				else
					raise DifInvalidIndicatorError, "Invalid type indicator [#{n[0]}]"
				end
			end
		end
	end

	# Returns the length of the data (number of rows)
	def length
		self.data.length
	end

	# Iterates each item - used by Enumerable.
	def each &block
		self.data.each { |d| block.call(d) }
	end
end