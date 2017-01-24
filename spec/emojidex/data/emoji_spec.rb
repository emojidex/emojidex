# encoding: utf-8

require 'spec_helper'

describe Emojidex::Data::Emoji do
  let(:emoji) do
    Emojidex::Data::Emoji.new moji: '🌠', code: 'shooting_star',
                              code_ja: '流れ星', category: 'cosmos',
                              unicode: '1f320'
  end

  let(:combination_info) do
    [
      {
        base: 'star',
        component_layer_order: [2, 0, 1, 3],
        components: [
          ['a', 'b', 'c'],
          ['d', 'e', ''],
          ['g', 'h', '']
        ]
      },
      {
        base: 'moon',
        components: [
          ['a', 'b', 'c'],
          ['d', 'e', ''],
          ['g', 'h', '']
        ]
      }
    ]
  end

  describe 'attributes' do
    it 'assings all attributes or defaults' do
      expect(emoji.moji).to eq('🌠')
      expect(emoji.code).to eq('shooting_star')
      expect(emoji.code_ja).to eq('流れ星')
      expect(emoji.category).to eq(:cosmos)
      expect(emoji.unicode).to eq('1f320')
    end
  end

  describe '.to_s' do
    it 'outputs UTF moji when present' do
      expect(emoji.to_s).to eq('🌠')
    end

    it 'outputs emoji code when UTF is not present' do
      emoji.moji = nil
      expect(emoji.to_s).to eq(':shooting star:')
    end
  end

  describe '.to_hash' do
    it 'gets a hash containing emoji info' do
      expect(emoji.to_hash).to be_an_instance_of(Hash)
    end
  end

  describe '[]' do
    it 'acts like hash for lookup by key' do
      expect(emoji[:moji]).to eq(emoji.moji)
    end
  end

  describe '[]=' do
    it 'assigns a value in a hash by a key' do
      emoji[:code] = 'star_shot'
      expect(emoji.code).to eq('star_shot')
    end
  end

  describe '.to_json' do
    it 'outputs JSON info from the emoji' do
      expect(JSON.parse(emoji.to_json)).to be_an_instance_of(Hash)
    end
  end

  describe '.fill_combinations' do
    it 'fills the combinations array with combination object instances' do
      emoji.fill_combinations(combination_info)
      expect(emoji.combinations.first).to be_an_instance_of(Emojidex::Data::Combination)
      expect(emoji.combinations[0].component_layer_order).to eq([2, 0, 1, 3])
      expect(emoji.combinations[1].component_layer_order).to eq([0, 1, 2, 3])
      expect(emoji.combinations[0].base).to eq('star')
      expect(emoji.combinations[0].components[0]).to eq(['shooting_star'])
      expect(emoji.combinations[0].components[2]).to eq(['d', 'e', ''])
      expect(emoji.combinations[0].checksums[0]).to eq(
        {
          'shooting_star' => {
            svg:nil,
            png: {
              ldpi: nil,
              mdpi: nil,
              hdpi: nil,
              xhdpi: nil,
              xxhdpi: nil,
              xxxhdpi: nil,
              px8: nil,
              px16: nil,
              px32: nil,
              px64: nil,
              px128: nil,
              px256: nil,
              px512: nil,
              hanko: nil,
              seal: nil
            }
          }
        }
      )
    end
  end
end
