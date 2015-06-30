require 'spec_helper'

require './spec/fixtures/bookmark'

describe DataMapper::Property::URI do
  subject { DataMapper::TypesFixtures::Bookmark.properties[:uri] }

  let(:uri)     { Addressable::URI.parse(uri_str)        }
  let(:uri_str) { 'http://example.com/path/to/resource/' }

  it { is_expected.to be_instance_of(described_class) }

  describe '.dump' do
    context 'with an instance of Addressable::URI' do
      it 'returns the URI as a String' do
        expect(subject.dump(uri)).to eql(uri_str)
      end
    end

    context 'with nil' do
      it 'returns nil' do
        expect(subject.dump(nil)).to be(nil)
      end
    end

    context 'with an empty string' do
      it 'returns an empty URI' do
        expect(subject.dump('')).to eql('')
      end
    end
  end

  describe '.load' do
    context 'with a string' do
      it 'returns the URI as an Addressable::URI' do
        expect(subject.load(uri_str)).to eql(uri)
      end
    end

    context 'with nil' do
      it 'returns nil' do
        expect(subject.load(nil)).to be(nil)
      end
    end

    context 'with an empty string' do
      it 'returns an empty URI' do
        expect(subject.load('')).to eql(Addressable::URI.parse(''))
      end
    end

    context 'with a non-normalized URI' do
      let(:uri_str) { 'http://www.example.com:80'                       }
      let(:uri)     { Addressable::URI.parse('http://www.example.com/') }

      it 'returns the URI as a normalized Addressable::URI' do
        expect(subject.load(uri_str)).to eql(uri)
      end
    end
  end

  describe '.typecast' do
    context 'with an instance of Addressable::URI' do
      it 'does nothing' do
        expect(subject.typecast(uri)).to eql(uri)
      end
    end

    context 'with a string' do
      it 'delegates to .load' do
        expect(subject.typecast(uri_str)).to eql(uri)
      end
    end

    context 'with nil' do
      it 'returns nil' do
        expect(subject.typecast(nil)).to be(nil)
      end
    end
  end
end
