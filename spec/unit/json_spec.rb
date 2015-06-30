require 'spec_helper'
require 'shared/identity_function_group'
require './spec/fixtures/person'

describe DataMapper::Property::Json do
  before :all do
    @property = DataMapper::TypesFixtures::Person.properties[:positions]
  end

  describe '#valid?' do
    before :all do
      @string = '{ "foo": "bar" }'
      @json   = MultiJson.decode(@string)
    end

    describe "with a String" do
      subject { @property.valid?(@input) }
      it { expect(subject).to be(true) }
    end

    describe "with JSON" do
      subject { @property.valid?(@json) }
      it { expect(subject).to be(true) }
    end
  end

  describe '.load' do
    describe 'when nil is provided' do
      it 'returns nil' do
        expect(@property.load(nil)).to be_nil
      end
    end

    describe 'when Json encoded primitive string is provided' do
      it 'returns decoded value as Ruby string' do
        expect(@property.load(MultiJson.encode(:value => 'JSON encoded string'))).to eq({ 'value' => 'JSON encoded string' })
      end
    end

    describe 'when something else is provided' do
      it 'raises ArgumentError with a meaningful message' do
        expect {
          @property.load(:sym)
        }.to raise_error(ArgumentError, '+value+ of a property of JSON type must be nil or a String')
      end
    end
  end

  describe '.dump' do
    describe 'when nil is provided' do
      it 'returns nil' do
        expect(@property.dump(nil)).to be_nil
      end
    end

    describe 'when Json encoded primitive string is provided' do
      it 'does not do double encoding' do
        expect(@property.dump('Json encoded string')).to eq('Json encoded string')
      end
    end

    describe 'when regular Ruby string is provided' do
      it 'dumps argument to Json' do
        expect(@property.dump('dump me (to JSON)')).to eq('dump me (to JSON)')
      end
    end

    describe 'when Ruby array is provided' do
      it 'dumps argument to Json' do
        expect(@property.dump([1, 2, 3])).to eq('[1,2,3]')
      end
    end

    describe 'when Ruby hash is provided' do
      it 'dumps argument to Json' do
        expect(@property.dump({ :datamapper => 'Data access layer in Ruby' })).
          to eq('{"datamapper":"Data access layer in Ruby"}')
      end
    end
  end

  describe '.typecast' do
    class ::SerializeMe
      attr_accessor :name
    end

    describe 'when given instance of a Hash' do
      before :all do
        @input = { :library => 'DataMapper' }

        @result = @property.typecast(@input)
      end

      include_examples 'identity function'
    end

    describe 'when given instance of an Array' do
      before :all do
        @input = %w[ dm-core dm-more ]

        @result = @property.typecast(@input)
      end

      include_examples 'identity function'
    end

    describe 'when given nil' do
      before :all do
        @input = nil

        @result = @property.typecast(@input)
      end

      include_examples 'identity function'
    end

    describe 'when given JSON encoded value' do
      before :all do
        @input = '{ "value": 11 }'

        @result = @property.typecast(@input)
      end

      it 'decodes value from JSON' do
        expect(@result).to eq({ 'value' => 11 })
      end
    end

    describe 'when given instance of a custom class' do
      before :all do
        @input      = SerializeMe.new
        @input.name = 'Hello!'

        # @result = @property.typecast(@input)
      end

      it 'attempts to load value from JSON string'
    end
  end
end
