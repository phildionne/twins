require 'spec_helper'

describe Twins do

  describe :consolidate do

    describe "with an empty collection" do
      let(:collection) { [] }
      it { expect(Twins.consolidate(collection)).to eq(nil) }
    end

    describe "with a collection of all same elements" do
      let(:collection) { [{ a: 'a' }, { a: 'a' }, { a: 'a' }] }
      it { expect(Twins.consolidate(collection)).to eq({ a: 'a' }.with_indifferent_access) }
    end

    describe "with a collection of all different elements" do
      let(:collection) { [{ a: 'a' }, { b: 'b' }, { c: 'c' }] }
      it { expect(Twins.consolidate(collection)).to eq({ a: 'a', b: 'b', c: 'c' }.with_indifferent_access) }
    end

    describe "with a collection of same and different elements" do
      let(:collection) { [{ a: 'a', b: 'b' }, { a: 'a', b: 'b' }, { a: 'a', b: 'b', c: 'c' }] }
      it { expect(Twins.consolidate(collection)).to eq({ a: 'a', b: 'b', c: 'c' }.with_indifferent_access) }
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
      it { expect(Twins.consolidate(collection)).to eq({ a: 'a', b: [{ x: 'x' }] }.with_indifferent_access) }
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
      it { expect(Twins.consolidate(collection)).to eq({ a: 'a', b: { x: 'x', y: 'y' }}.with_indifferent_access) }
    end

    describe "with Objects defining '#to_h'" do
      before do
        class Klass
          attr_accessor :a, :b
          def initialize(attrs = {}); attrs.each { |k,v| send("#{k}=", v) }; end
          def to_h; {a: a, b: b}; end
        end
      end
      let(:collection) { [Klass.new({a: 'some', b: 'thing'}), Klass.new({a: 'another', b: 'thing'})] }

      it { expect(Twins.consolidate(collection)).to eq({ a: 'some', b: 'thing' }.with_indifferent_access) }
    end

    context "with options" do

      describe :priority do

        describe "a String" do
          let(:options) { { priority: { element: 'something' } } }

          describe "with a single match" do
            let(:collection) { [{ element: 'something' }, { element: 'something' }] }
            it { expect(Twins.consolidate(collection, options)).to eq({ element: 'something' }.with_indifferent_access) }
          end

          describe "with multiple matches" do
            let(:collection) { [{ element: 'some' }, { element: 'thing' }, { element: 'something' }] }
            it { expect(Twins.consolidate(collection, options)).to eq({ element: 'something' }.with_indifferent_access) }
          end

          describe "with no match" do
            let(:collection) { [{ element: 'thing1' }, { element: 'thing2' }] }
            it { expect(Twins.consolidate(collection, options)).to eq({ element: 'thing1' }.with_indifferent_access) }
          end
        end

        describe "a Numeric" do
          let(:options) { { priority: { element: 10 } } }

          describe "with no difference and no mode" do
            let(:collection) { [{ element: 10 }] }
            it { expect(Twins.consolidate(collection, options)).to eq({ element: 10 }.with_indifferent_access) }
          end

          describe "with no difference and a mode" do
            let(:collection) { [{ element: 10 }, { element: 10 }] }
            it { expect(Twins.consolidate(collection, options)).to eq({ element: 10 }.with_indifferent_access) }
          end

          describe "with a higher difference and no mode" do
            let(:collection) { [{ element: 1 }, { element: 2 }] }
            it { expect(Twins.consolidate(collection, options)).to eq({ element: 2 }.with_indifferent_access) }
          end

          describe "with a higher difference and a mode" do
            let(:collection) { [{ element: 1 }, { element: 1 }, { element: 2 }] }
            it { expect(Twins.consolidate(collection, options)).to eq({ element: 2 }.with_indifferent_access) }
          end

          describe "with a lower difference and no mode" do
            let(:collection) { [{ element: 1 }, { element: 2 }] }
            it { expect(Twins.consolidate(collection, options)).to eq({ element: 2 }.with_indifferent_access) }
          end

          describe "with a lower difference and a mode" do
            let(:collection) { [{ element: 1 }, { element: 2 }, { element: 2 }] }
            it { expect(Twins.consolidate(collection, options)).to eq({ element: 2 }.with_indifferent_access) }
          end
        end
      end
    end
  end

  describe :pick do

    describe "with an empty collection" do
      let(:collection) { [] }
      it { expect(Twins.pick(collection)).to eq(nil) }
    end

    describe "with a collection of all same elements" do
      let(:element1) { { a: 'a' } }
      let(:element2) { { a: 'a' } }
      let(:element3) { { a: 'a' } }
      let(:collection) { [element1, element2, element3] }
      it { expect(Twins.pick(collection)).to be(element1) }
    end

    describe "with a collection of all different elements" do
      let(:element1) { { a: 'a' } }
      let(:element2) { { b: 'b' } }
      let(:element3) { { c: 'c' } }
      let(:collection) { [element1, element2, element3] }
      it { expect(Twins.pick(collection)).to be(element1) }
    end

    describe "with a collection of same and different elements" do
      let(:element1) { { a: 'a', b: 'b' } }
      let(:element2) { { a: 'a', b: 'b' } }
      let(:element3) { { a: 'a', b: 'b', c: 'c' } }
      let(:collection) { [element1, element2, element3] }
      it { expect(Twins.pick(collection)).to be(element3) }
    end

    describe "with Objects defining '#to_h'" do
      before do
        class Klass
          attr_accessor :a, :b
          def initialize(attrs = {}); attrs.each { |k,v| send("#{k}=", v) }; end
          def to_h; {a: a, b: b}; end
        end
      end
      let(:element1) { Klass.new({a: 'some', b: 'thing'}) }
      let(:element2) { Klass.new({a: 'another', b: 'thing'}) }
      let(:collection) { [element1, element2] }

      it { expect(Twins.pick(collection)).to be(element1) }
    end
  end
end
