require 'spec_helper'

try_spec do

  # FIXME: DirtyMinder is currently unsupported on RBX, because unlike the other
  # supported Rubies, RBX core class (e.g. Array, Hash) methods use #send().  In
  # other words, the other Rubies don't use #send() (they map directly to their
  # C functions).
  #
  # The current methodology takes advantage of this by using #send() to forward
  # method invocations we've hooked.  Supporting RBX will require finding
  # another way, possibly for all Rubies.  In the meantime, something is better
  # than nothing.
  next if defined?(RUBY_ENGINE) and RUBY_ENGINE == 'rbx'

  require './spec/fixtures/person'

  describe DataMapper::TypesFixtures::Person do
    supported_by :each do
      before :each do
        @resource = DataMapper::TypesFixtures::Person.new(:name => 'Thomas Edison')
      end

      describe 'with positions indirectly mutated as a hash' do
        before :each do
          @resource.positions = {
            'company' => "Soon To Be Dirty, LLC",
            'title'   => "Layperson",
            'details' => { 'awesome' => true },
          }
          @resource.save
          @resource.reload
          expect(@resource.positions['title']).to eq('Layperson')
        end

        describe "when I change positions" do
          before :each do
            expect(@resource.clean?).to eq(true)
            @resource.positions['title'] = 'Chief Layer of People'
            @resource.save
            @resource.reload
          end

          it "should remember the new position" do
            expect(@resource.positions['title']).to eq('Chief Layer of People')
          end
        end

        describe "when I add a new attribute of the position" do
          before :each do
            expect(@resource.clean?).to eq(true)
            @resource.positions['pays_buttloads_of_money'] = true
            @resource.save
            @resource.reload
          end

          it "should remember the new attribute" do
            expect(@resource.positions['pays_buttloads_of_money']).to be(true)
          end
        end

        describe "when I change the details of the position" do
          before :each do
            expect(@resource.clean?).to eq(true)
            @resource.positions['details'].merge!('awesome' => "VERY TRUE")
            @resource.save
            @resource.reload
          end

          it "should remember the changed detail" do
            pending "not supported (YET)"
              # TODO: Not supported (yet?) -- this is a much harder problem to
              # solve: using mutating accessors of nested objects.  We could
              # detect it from #dirty? (using the #hash method), but #dirty?
              # only returns the status of known-mutated properties (not full,
              # on-demand scan of object dirty-ness).
            @resource.positions['details']['awesome'].should == 'VERY TRUE'
          end
        end

        describe "when I reload the resource while the property is dirty" do
          before :each do
            @resource.positions['title'] = 'Chief Layer of People'
            @resource.reload
          end

          it "should reflect the previously set/persisted value" do
            expect(@resource.positions).not_to be_nil
            expect(@resource.positions['title']).to eq('Layperson')
          end
        end

      end # positions indirectly mutated as a hash

      describe 'with positions indirectly mutated as an array' do
        before :each do
          @resource.positions = [
            { 'company' => "Soon To Be Dirty, LLC",
              'title'   => "Layperson",
              'details' => { 'awesome' => true },
            },
          ]
          @resource.save
          @resource.reload
          expect(@resource.positions.first['title']).to eq('Layperson')
        end

        describe "when I remove the position" do
          before :each do
            expect(@resource.clean?).to eq(true)
            @resource.positions.pop
            @resource.save
            @resource.reload
          end

          it "should know there aren't any positions" do
            expect(@resource.positions).to eq([])
          end
        end

        describe "when I add a new position" do
          before :each do
            expect(@resource.clean?).to eq(true)
            @resource.positions << {
              'company' => "Down and Dirty, LP",
              'title'   => "Porn Star",
              'details' => { 'awesome' => "also true" },
            }
            @resource.save
            @resource.reload
          end

          it "should know there's two positions" do
            expect(@resource.positions.length).to eq(2)
          end

          it "should know which position is which" do
            expect(@resource.positions.first['title']).to eq("Layperson")
            expect(@resource.positions.last['title']).to eq("Porn Star")
          end

          describe "when I change the details of one of the positions" do
            before :each do
              @resource.positions.last['details'].merge!('high_risk' => true)
              @resource.save
              @resource.reload
            end

            it "should remember the changed detail" do
              pending "not supported (YET)"
                # TODO: Not supported (yet?) -- this is a much harder problem to
                # solve: using mutating accessors of nested objects.  We could
                # detect it from #dirty? (using the #hash method), but #dirty?
                # only returns the status of known-mutated properties (not full,
                # on-demand scan of object dirty-ness).
              @resource.positions.last['details']['high_risk'].should == true
            end
          end
        end # when I add a new position

        describe "when I remove the position with a block-based mutator" do
          before :each do
            expect(@resource.clean?).to eq(true)
            @resource.positions.reject! { |_| true }
            @resource.save
            @resource.reload
          end

          it "should know there aren't any positions" do
            expect(@resource.positions).to eq([])
          end
        end

        describe "when I mutate positions through a reference" do
          before :each do
            expect(@resource.clean?).to eq(true)
            @positions = @resource.positions
            @positions << {
              'company' => "Ooga Booga, Inc",
              'title'   => "Rocker",
            }
          end

          it "should reflect the change in both the property and the reference" do
            expect(@resource.positions.length).to eq(2)
            expect(@resource.positions.last['title']).to eq('Rocker')
            expect(@positions.last['title']).to eq('Rocker')
          end
        end

      end # positions indirectly mutated as an array

    end
  end
end
