require 'spec_helper'

require './spec/fixtures/tshirt'

describe DataMapper::Property::Flag do
  describe '.dump' do
    before :all do
      @flag = DataMapper::TypesFixtures::TShirt.property(
        :stuff, DataMapper::Property::Flag[:first, :second, :third, :fourth, :fifth])

      @property_klass = DataMapper::Property::Flag
    end

  include_examples "A property with flags"

    describe 'when argument matches a value in the flag map' do
      before :all do
        @result = @flag.dump(:first)
      end

      it 'returns flag bit of value' do
        expect(@result).to eq(1)
      end
    end

    describe 'when argument matches 2nd value in the flag map' do
      before :all do
        @result = @flag.dump(:second)
      end

      it 'returns flag bit of value' do
        expect(@result).to eq(2)
      end
    end

    describe 'when argument matches multiple Symbol values in the flag map' do
      before :all do
        @result = @flag.dump([ :second, :fourth ])
      end

      it 'builds binary flag from key values of all matches' do
        expect(@result).to eq(10)
      end
    end

    describe 'when argument matches multiple string values in the flag map' do
      before :all do
        @result = @flag.dump(['first', 'second', 'third', 'fourth', 'fifth'])
      end

      it 'builds binary flag from key values of all matches' do
        expect(@result).to eq(31)
      end
    end

    describe 'when argument does not match a single value in the flag map' do
      before :all do
        @result = @flag.dump(:zero)
      end

      it 'returns zero' do
        expect(@result).to eq(0)
      end
    end

    describe 'when argument contains duplicate flags' do
      before :all do
        @result = @flag.dump([ :second, :fourth, :second ])
      end

      it 'behaves the same as if there were no duplicates' do
        expect(@result).to eq(@flag.dump([ :second, :fourth ]))
      end
    end
  end

  describe '.load' do
    before :all do
      @flag = DataMapper::TypesFixtures::TShirt.property(:stuff, DataMapper::Property::Flag, :flags => [:uno, :dos, :tres, :cuatro, :cinco])
    end

    describe 'when argument matches a key in the flag map' do
      before :all do
        @result = @flag.load(4)
      end

      it 'returns array with a single matching element' do
        expect(@result).to eq([ :tres ])
      end
    end

    describe 'when argument matches multiple keys in the flag map' do
      before :all do
        @result = @flag.load(10)
      end

      it 'returns array of matching values' do
        expect(@result).to eq([ :dos, :cuatro ])
      end
    end

    describe 'when argument does not match a single key in the flag map' do
      before :all do
        @result = @flag.load(nil)
      end

      it 'returns an empty array' do
        expect(@result).to eq([])
      end
    end
  end
end
