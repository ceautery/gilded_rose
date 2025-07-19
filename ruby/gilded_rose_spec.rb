# frozen_string_literal: true

require 'rspec'

require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do
  context 'with a simple item' do
    subject(:gr) { GildedRose.new([item]) }

    let :item do
      Item.new('foo', 0, 0)
    end

    before { gr.update_quality }

    it 'does not change the name' do
      expect(item.name).to eq('foo')
    end

    it 'quality is never negative' do
      expect(item.quality).to eq(0)
    end

    it 'sell in decrements' do
      expect(item.sell_in).to eq(-1)
    end
  end
end
