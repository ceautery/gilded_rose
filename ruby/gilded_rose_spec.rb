# frozen_string_literal: true

require 'rspec'

require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do
  subject(:gr) { GildedRose.new([item]) }

  context 'with a zero quality item at sell date' do
    let(:item) { Item.new('foo', 0, 0) }

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

  context 'with a one quality item before sell date' do
    let(:item) { Item.new('foo', 1, 1) }

    it 'quality decrements' do
      expect { gr.update_quality }.to change { item.quality }.by(-1)
    end

    it 'sell in decrements' do
      expect { gr.update_quality }.to change { item.sell_in }.by(-1)
    end
  end

  context 'with a legendary item' do
    let(:item) { Item.new('Sulfuras, Hand of Ragnaros', 1, 1) }

    it 'quality is fixed' do
      expect { gr.update_quality }.not_to(change { item.quality })
    end

    it 'sell in is fixed' do
      expect { gr.update_quality }.not_to(change { item.sell_in })
    end
  end

  context 'with cheese' do
    let(:item) { Item.new('Aged Brie', 1, 49) }

    it 'increments quality' do
      expect { gr.update_quality }.to change { item.quality }.by(1)
    end
  end

  context 'with cheese already at max quality' do
    let(:item) { Item.new('Aged Brie', 1, 50) }

    it 'quality stops at 50' do
      expect { gr.update_quality }.not_to(change { item.quality })
    end
  end
end
