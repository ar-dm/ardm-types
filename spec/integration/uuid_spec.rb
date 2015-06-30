require 'spec_helper'
require './spec/fixtures/network_node'

describe DataMapper::TypesFixtures::NetworkNode do
  supported_by :all do
    describe 'with UUID set as UUID object' do
      before do
        @uuid_string = 'b0fc632e-d744-4821-afe3-4ea0701859ee'
        @uuid        = UUIDTools::UUID.parse(@uuid_string)
        @resource    = DataMapper::TypesFixtures::NetworkNode.new(:uuid => @uuid)

        expect(@resource.save).to be(true)
      end

      describe 'when reloaded' do
        before do
          @resource.reload
        end

        it 'has the same UUID string' do
          expect(@resource.uuid.to_s).to eq(@uuid_string)
        end

        it 'returns UUID as an object' do
          expect(@resource.uuid).to be_an_instance_of(UUIDTools::UUID)
        end
      end
    end

    describe 'with UUID set as a valid UUID string' do
      before do
        @uuid  = 'b0fc632e-d744-4821-afe3-4ea0701859ee'
        @resource = DataMapper::TypesFixtures::NetworkNode.new(:uuid => @uuid)
      end

      describe 'when reloaded' do
        before do
          @resource.reload
        end

        it 'has the same UUID string' do
          expect(@resource.uuid.to_s).to eq(@uuid)
        end

        it 'returns UUID as an object' do
          expect(@resource.uuid).to be_an_instance_of(UUIDTools::UUID)
        end
      end
    end

    describe 'with UUID set as invalid UUID string' do
      before do
        @uuid  = 'meh'
        @operation = lambda do
          DataMapper::TypesFixtures::NetworkNode.new(:uuid => @uuid)
        end
      end

      describe 'when assigned UUID' do
        it 'raises ArgumentError' do
          expect(@operation).to raise_error(ArgumentError, /Invalid UUID format/)
        end
      end
    end

    describe 'with UUID set as a blank string' do
      before do
        @uuid  = ''
        @operation = lambda do
          DataMapper::TypesFixtures::NetworkNode.new(:uuid => @uuid)
        end
      end

      describe 'when assigned UUID' do
        it 'raises ArgumentError' do
          expect(@operation).to raise_error(ArgumentError, /Invalid UUID format/)
        end
      end
    end

    describe 'with missing UUID' do
      before do
        @uuid  = nil
        @resource = DataMapper::TypesFixtures::NetworkNode.new(:uuid => @uuid)
      end

      describe 'when reloaded' do
        before do
          @resource.reload
        end

        it 'has no UUID' do
          expect(@resource.uuid).to be_nil
        end
      end
    end
  end
end
