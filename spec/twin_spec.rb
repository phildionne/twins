require 'spec_helper'

describe Twin do

  describe :consolidate do

    describe "with an empty collection" do
      let(:collection) { [] }
      it { expect(Twin.consolidate(collection)).to eq(nil) }
    end

    describe "with a collection of all same elements" do
      let(:collection) { [{ a: 'a' }, { a: 'a' }, { a: 'a' }] }
      it { expect(Twin.consolidate(collection)).to eq({ a: 'a' }.with_indifferent_access) }
    end

    describe "with a collection of all different elements" do
      let(:collection) { [{ a: 'a' }, { b: 'b' }, { c: 'c' }] }
      it { expect(Twin.consolidate(collection)).to eq({ a: 'a', b: 'b', c: 'c' }.with_indifferent_access) }
    end

    describe "with a collection of same and different elements" do
      let(:collection) { [{ a: 'a', b: 'b' }, { a: 'a', b: 'b' }, { a: 'a', b: 'b', c: 'c' }] }
      it { expect(Twin.consolidate(collection)).to eq({ a: 'a', b: 'b', c: 'c' }.with_indifferent_access) }
    end

    describe "with nested arrays" do
      let(:collection) do
        [
          {
            a: 'a',
            b: [{ x: 'xx' }]
          },
          {
            a: 'a',
            b: [{ x: 'x' }]
          },
          {
            a: 'aa',
            b: [{ x: 'x' }]
          }
        ]
      end
      it { expect(Twin.consolidate(collection)).to eq({ a: 'a', b: [{ x: 'x' }] }.with_indifferent_access) }
    end

    describe "with nested hashes" do
      let(:collection) do
        [
          { a: 'a',
            b: {
              x: 'xx',
              y: 'yy'
            }
          },
          { a: 'a',
            b: {
              x: 'x',
              y: 'y'
            }
          },
          { a: 'aa',
            b: {
              x: 'x',
              y: 'y'
            }
          }
        ]
      end
      it { expect(Twin.consolidate(collection)).to eq({ a: 'a', b: { x: 'x', y: 'y' }}.with_indifferent_access) }
    end

    describe "with Objects defining instance variables" do
      before do
        class Klass
          attr_accessor :a, :b
          def initialize(attrs = {}); attrs.each { |k,v| send("#{k}=", v) }; end
        end
      end
      let(:collection) { [Klass.new({a: 'some', b: 'thing'}), Klass.new({a: 'another', b: 'thing'})] }

      it { expect(Twin.consolidate(collection)).to eq({ a: 'some', b: 'thing' }.with_indifferent_access) }
    end

    context "with options" do

      describe :priority do

        describe "a String" do
          let(:options) { { priority: { element: 'something' } } }

          describe "with a single match" do
            let(:collection) { [{ element: 'something' }, { element: 'something' }] }
            it { expect(Twin.consolidate(collection, options)).to eq({ element: 'something' }.with_indifferent_access) }
          end

          describe "with multiple matches" do
            let(:collection) { [{ element: 'some' }, { element: 'thing' }, { element: 'something' }] }
            it { expect(Twin.consolidate(collection, options)).to eq({ element: 'something' }.with_indifferent_access) }
          end

          describe "with no match" do
            let(:collection) { [{ element: 'thing1' }, { element: 'thing2' }] }
            it { expect(Twin.consolidate(collection, options)).to eq({ element: 'thing1' }.with_indifferent_access) }
          end
        end

        describe "a Numeric" do
          let(:options) { { priority: { element: 10 } } }

          describe "with no difference and no mode" do
            let(:collection) { [{ element: 10 }] }
            it { expect(Twin.consolidate(collection, options)).to eq({ element: 10 }.with_indifferent_access) }
          end

          describe "with no difference and a mode" do
            let(:collection) { [{ element: 10 }, { element: 10 }] }
            it { expect(Twin.consolidate(collection, options)).to eq({ element: 10 }.with_indifferent_access) }
          end

          describe "with a higher difference and no mode" do
            let(:collection) { [{ element: 1 }, { element: 2 }] }
            it { expect(Twin.consolidate(collection, options)).to eq({ element: 2 }.with_indifferent_access) }
          end

          describe "with a higher difference and a mode" do
            let(:collection) { [{ element: 1 }, { element: 1 }, { element: 2 }] }
            it { expect(Twin.consolidate(collection, options)).to eq({ element: 2 }.with_indifferent_access) }
          end

          describe "with a lower difference and no mode" do
            let(:collection) { [{ element: 1 }, { element: 2 }] }
            it { expect(Twin.consolidate(collection, options)).to eq({ element: 2 }.with_indifferent_access) }
          end

          describe "with a lower difference and a mode" do
            let(:collection) { [{ element: 1 }, { element: 2 }, { element: 2 }] }
            it { expect(Twin.consolidate(collection, options)).to eq({ element: 2 }.with_indifferent_access) }
          end
        end
      end
    end
  end
end
