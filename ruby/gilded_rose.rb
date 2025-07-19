# frozen_string_literal: true

# Updates quality for items sold at the GR
class GildedRose
  def initialize(items)
    @items = items
  end

  def legendary?(item)
    item.name == 'Sulfuras, Hand of Ragnaros'
  end

  def appreciates?(item)
    item.name == 'Aged Brie' || backstage?(item)
  end

  def backstage?(item)
    item.name == 'Backstage passes to a TAFKAL80ETC concert'
  end

  def decrement_item_quality(item)
    item.quality = [item.quality - 1, 0].max
  end

  def increment_item_quality(item)
    qual = item.quality + 1
    if backstage?(item)
      qual += 1 if item.sell_in < 11
      qual += 1 if item.sell_in < 6
    end
    item.quality = [qual, 50].min
  end

  def past_date_adjustment(item)
    if item.name != 'Aged Brie'
      if !backstage?(item)
        decrement_item_quality(item)
      else
        item.quality = 0
      end
    elsif item.quality < 50
      item.quality = item.quality + 1
    end
  end

  def update_quality
    @items.each do |item|
      next if legendary?(item)

      if appreciates?(item)
        increment_item_quality(item)
      else
        decrement_item_quality(item)
      end

      item.sell_in = item.sell_in - 1

      past_date_adjustment(item) if item.sell_in.negative?
    end
  end
end

# Stats for an item sold at the GR
class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
