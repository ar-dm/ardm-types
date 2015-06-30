require 'spec_helper'

try_spec do

  require './spec/fixtures/bookmark'

  describe DataMapper::TypesFixtures::Bookmark do
    supported_by :each do
      describe 'without URI' do
        before :each do
          @uri = nil
          @resource = DataMapper::TypesFixtures::Bookmark.new(
            :title  => 'Check this out',
            :uri    => @uri,
            :shared => false,
            :tags   => %w[ misc ]
          )

          expect(@resource.save).to be(true)
        end

        it 'can be found by uri' do
          expect(DataMapper::TypesFixtures::Bookmark.first(:uri => @uri)).to eq(@resource)
        end

        describe 'when reloaded' do
          before :each do
            @resource.reload
          end

          it 'has no uri' do
            expect(@resource.uri).to be_nil
          end
        end
      end

      describe 'with a blank URI' do
        before :each do
          @uri = ''
          DataMapper::TypesFixtures::Bookmark.auto_migrate!
          @resource = DataMapper::TypesFixtures::Bookmark.new(
            :title  => 'Check this out',
            :uri    => @uri,
            :shared => false,
            :tags   => %w[ misc ]
          )

          expect(@resource.save).to be(true)
        end

        it 'can be found by uri' do
          expect(DataMapper::TypesFixtures::Bookmark.first(:uri => @uri)).to eq(@resource)
        end

        describe 'when reloaded' do
          before :each do
            @resource.reload
          end

          it 'is loaded as URI object' do
            expect(@resource.uri).to be_an_instance_of(Addressable::URI)
          end

          it 'has the same original URI' do
            expect(@resource.uri.to_s).to eq(@uri)
          end
        end
      end

      describe 'with invalid URI' do
        before :each do
          @uri = 'this is def. not URI'
          @resource = DataMapper::TypesFixtures::Bookmark.new(
            :title  => 'Check this out',
            :uri    => @uri,
            :shared => false,
            :tags   => %w[ misc ]
          )
        end

        it 'is perfectly valid (URI type does not provide auto validations)' do
          expect(@resource.save).to be(true)
        end
      end

      %w[
      http://apple.com
      http://www.apple.com
      http://apple.com/
      http://apple.com/iphone
      http://www.google.com/search?client=safari&rls=en-us&q=LED&ie=UTF-8&oe=UTF-8
      http://books.google.com
      http://books.google.com/
      http://db2.clouds.megacorp.net:8080
      https://github.com
      https://github.com/
      http://www.example.com:8088/never/ending/path/segments/
      http://db2.clouds.megacorp.net:8080/resources/10
      http://www.example.com:8088/never/ending/path/segments
      http://books.google.com/books?id=uSUJ3VhH4BsC&printsec=frontcover&dq=subject:%22+Linguistics+%22&as_brr=3&ei=DAHPSbGQE5rEzATk1sShAQ&rview=1
      http://books.google.com:80/books?uid=14472359158468915761&rview=1
      http://books.google.com/books?id=Ar3-TXCYXUkC&printsec=frontcover&rview=1
      http://books.google.com/books/vp6ae081e454d30f89b6bca94e0f96fc14.js
      http://www.google.com/images/cleardot.gif
      http://books.google.com:80/books?id=Ar3-TXCYXUkC&printsec=frontcover&rview=1#PPA5,M1
      http://www.hulu.com/watch/64923/terminator-the-sarah-connor-chronicles-to-the-lighthouse
      http://hulu.com:80/browse/popular/tv
      http://www.hulu.com/watch/62475/the-simpsons-gone-maggie-gone#s-p1-so-i0
      ].each do |uri|
        describe "with URI set to '#{uri}'" do
          before :each do
            @resource = DataMapper::TypesFixtures::Bookmark.new(
              :title  => 'Check this out',
              :uri    => uri,
              :shared => false,
              :tags   => %w[ misc ]
            )

            expect(@resource.save).to be(true)
          end

          it 'can be found by uri' do
            expect(DataMapper::TypesFixtures::Bookmark.first(:uri => uri)).not_to be_nil
          end

          describe 'when reloaded' do
            before :each do
              @resource.reload
            end

            it 'has the same original URI' do
              expect(@resource.uri.to_s).to eql(uri)
            end
          end
        end
      end
    end
  end
end
