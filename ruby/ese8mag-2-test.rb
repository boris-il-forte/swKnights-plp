# === Exercise 4 ===
# A basic test framework

module Kernel
	def describe(description, &block)
		tests = Dsl.new.parse(description, block)
		tests.execute
	end
end

class Object
	def should
		self
	end
end

class Dsl
	
	def initialize
		@tests = {}
	end
	
	def parse(description, block)
		instance_eval(&block)
		Executor.new(description, @tests)
	end

	def it(description, &block)
		@tests[description] = block
	end

end

class Executor
	def initialize(description, tests)
		@description = description
		@tests = tests
		@success_count = 0
		@failure_count = 0
	end

	def execute()
		puts "#{@description}"
		@tests.each_pair do |desc, proc|
			print "- #{desc}"
			result = instance_eval(&proc)
			result ? @success_count += 1 : @failure_count += 1
			puts result ? "Success" : "Failure"
		end
		summary()
	end
	
	def summary()
		puts "\n #{@tests.keys.size} tests, #{@success_count} success, #{@failure_count} failed"
	end

end

describe "the test suite name" do
	it "should be true" do
		true.should == true
	end

	it "should show that an expression can be true" do
		(5 == 5).should == true
	end

	it "should be failing" do
		5.should == 6
	end

end
