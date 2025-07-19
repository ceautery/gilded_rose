# frozen_string_literal: true

require 'rspec'

require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do
  subject(:gr) { GildedRose.new(items) }

  context 'with a simple item' do
    let(:items) { [item] }

    describe 'a zero quality item at sell date' do
      let(:item) do
        Item.new('foo', 0, 0)
      end

      it 'does not change the name' do
        expect { gr.update_quality }.not_to(change { item.name })
      end

      it 'quality is never negative' do
        expect { gr.update_quality }.not_to(change { item.quality })
      end

      it 'sell in decrements' do
        expect { gr.update_quality }.to change { item.sell_in }.by(-1)
      end
    end

    describe 'a one quality item before sell date' do
      let(:item) do
        Item.new('foo', 1, 1)
      end

      it 'quality decrements' do
        expect { gr.update_quality }.to change { item.quality }.by(-1)
      end

      it 'sell in decrements' do
        expect { gr.update_quality }.to change { item.sell_in }.by(-1)
      end
    end
  end
end
