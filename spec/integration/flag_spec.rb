require 'spec_helper'
require './spec/fixtures/tshirt'

describe DataMapper::TypesFixtures::TShirt do
  supported_by :all do
    before do
      @resource = DataMapper::TypesFixtures::TShirt.new(
        :writing     => 'Fork you',
        :has_picture => true,
        :picture     => :octocat,
        :color       => :white
      )
    end

    describe 'with the default value' do
      it 'returns it as an array' do
        expect(@resource.size).to eql([DataMapper::TypesFixtures::TShirt.properties[:size].default])
      end
    end

    describe 'with multiple sizes' do
      describe 'dumped and loaded' do
        before do
          @resource.size = [ :xs, :medium ]
          expect(@resource.save).to be(true)
          @resource.reload
        end

        it 'returns size as array' do
          expect(@resource.size).to eq([ :xs, :medium ])
        end
      end
    end

    describe 'with a single size' do
      before do
        @resource.size = :large
      end

      describe 'dumped and loaded' do
        before do
          expect(@resource.save).to be(true)
          @resource.reload
        end

        it 'returns size as array with a single value' do
          expect(@resource.size).to eq([:large])
        end
      end
    end

    # Flag does not add any auto validations
    describe 'without size' do
      before do
        expect(@resource).to be_valid
        @resource.size = nil
      end

      it 'is valid' do
        expect(@resource).to be_valid
      end

      it 'has no errors' do
        expect(@resource.errors).to be_empty
      end
    end
  end
end
