require 'spec_helper'

describe DataMapper::Property::Csv do
  supported_by :all do
    before do
      class ::User
        include DataMapper::Resource
        property :id, Serial
        property :things, Csv
      end

      @property = User.properties[:things]
    end

    describe '.load' do
      describe 'when argument is a comma separated string' do
        before do
          @input  = 'uno,due,tre'
          @result = @property.load(@input)
        end

        it 'parses the argument using CVS parser' do
          expect(@result).to eq([ %w[ uno due tre ] ])
        end
      end

      describe 'when argument is an empty array' do
        before do
          @input    = []
          @result   = @property.load(@input)
        end

        it 'does not change the input' do
          expect(@result).to eq(@input)
        end
      end

      describe 'when argument is an empty hash' do
        before do
          @input    = {}
          @result   = @property.load(@input)
        end

        it 'returns nil' do
          expect(@result).to be_nil
        end
      end

      describe 'when argument is nil' do
        before do
          @input    = nil
          @result   = @property.load(@input)
        end

        it 'returns nil' do
          expect(@result).to be_nil
        end
      end

      describe 'when argument is an integer' do
        before do
          @input    = 7
          @result   = @property.load(@input)
        end

        it 'returns nil' do
          expect(@result).to be_nil
        end
      end

      describe 'when argument is a float' do
        before do
          @input    = 7.0
          @result   = @property.load(@input)
        end

        it 'returns nil' do
          expect(@result).to be_nil
        end
      end

      describe 'when argument is an array' do
        before do
          @input  = [ 1, 2, 3 ]
          @result = @property.load(@input)
        end

        it 'returns input as is' do
          expect(@result).to eql(@input)
        end
      end
    end

    describe '.dump' do
      describe 'when value is a list of lists' do
        before do
          @input  = [ %w[ uno due tre ], %w[ uno dos tres ] ]
          @result = @property.dump(@input)
        end

        it 'dumps value to comma separated string' do
          expect(@result).to eq("uno,due,tre\nuno,dos,tres\n")
        end
      end

      describe 'when value is a string' do
        before do
          @input  = 'beauty hides in the deep'
          @result = @property.dump(@input)
        end

        it 'returns input as is' do
          expect(@result).to eq(@input)
        end
      end

      describe 'when value is nil' do
        before do
          @input  = nil
          @result = @property.dump(@input)
        end

        it 'returns nil' do
          expect(@result).to be_nil
        end
      end

      describe 'when value is a hash' do
        before do
          @input  = { :library => 'DataMapper', :language => 'Ruby' }
          @result = @property.dump(@input)
        end

        it 'returns nil' do
          expect(@result).to be_nil
        end
      end
    end
  end
end
