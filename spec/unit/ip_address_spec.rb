require 'spec_helper'

require './spec/fixtures/network_node'

describe DataMapper::Property::IPAddress do
  before :all do
    @stored = '81.20.130.1'
    @input  = IPAddr.new(@stored)
    @property = DataMapper::TypesFixtures::NetworkNode.properties[:ip_address]
  end

  describe '#valid?' do
    describe "with a String" do
      subject { @property.valid?(@stored) }
      it { expect(subject).to be(true) }
    end

    describe "with an IPAddr" do
      subject { @property.valid?(@input) }
      it { expect(subject).to be(true) }
    end
  end

  describe '.dump' do
    describe 'when argument is an IP address given as Ruby object' do
      before :all do
        @result = @property.dump(@input)
      end

      it 'dumps input into a string' do
        expect(@result).to eq(@stored)
      end
    end

    describe 'when argument is nil' do
      before :all do
        @result = @property.dump(nil)
      end

      it 'returns nil' do
        expect(@result).to be_nil
      end
    end

    describe 'when input is a blank string' do
      before :all do
        @result = @property.dump('')
      end

      it 'retuns a blank string' do
        expect(@result).to eq('')
      end
    end
  end

  describe '.load' do
    describe 'when argument is a valid IP address as a string' do
      before :all do
        @result = @property.load(@stored)
      end

      it 'returns IPAddr instance from stored value' do
        expect(@result).to eq(@input)
      end
    end

    describe 'when argument is nil' do
      before :all do
        @result = @property.load(nil)
      end

      it 'returns nil' do
        expect(@result).to be_nil
      end
    end

    describe 'when argument is a blank string' do
      before :all do
        @result = @property.load('')
      end

      it 'returns IPAddr instance from stored value' do
        expect(@result).to eq(IPAddr.new('0.0.0.0'))
      end
    end

    describe 'when argument is an Array instance' do
      before :all do
        @operation = lambda { @property.load([]) }
      end

      it 'raises ArgumentError with a meaningful message' do
        expect(@operation).to raise_error(ArgumentError, '+value+ must be nil or a String')
      end
    end
  end

  describe '.typecast' do
    describe 'when argument is an IpAddr object' do
      before :all do
        @result = @property.typecast(@input)
      end

      it 'does not change the value' do
        expect(@result).to eq(@input)
      end
    end

    describe 'when argument is a valid IP address as a string' do
      before :all do
        @result = @property.typecast(@stored)
      end

      it 'instantiates IPAddr instance' do
        expect(@result).to eq(@input)
      end
    end
  end
end
