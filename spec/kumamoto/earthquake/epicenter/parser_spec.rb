require 'spec_helper'

RSpec.describe Kumamoto::Earthquake::Epicenter::Parser do
  let(:parser) { described_class.new }

  describe '.parse_header' do
    let(:row) { ["", "地震の発生日時", "震央地名", "緯度", "経度", "深さ", "Ｍ", "最大震度"] }
    let(:expected) {
      {
         1 => :occured_at,
         2 => :name,
         3 => :latitude,
         4 => :longitude,
         5 => :depth,
         6 => :magnitude,
         7 => :japanese_scale
      }
    }
    before { parser.parse_header(row) }
    it { expect(parser.header_map).to eq expected }
  end

  describe '.parse_row' do
    let(:header) { ["", "地震の発生日時", "震央地名", "緯度", "経度", "深さ", "Ｍ", "最大震度"] }
    let(:row) { ["1", "2016/04/14 20:58:19.4", "東京都多摩東部", "35°39.1′N", "139°33.1′E", "45km", "Ｍ3.6", "２"] }
    before {
      parser.parse_header(header)
    }
    subject { parser.parse_row("ID=12345", row) }
    it { is_expected.not_to be_nil }
  end

  describe '.parse_occured_at' do
    subject { parser.parse_occured_at('2016/04/15 23:17:31.6').iso8601(1) }
    it { is_expected.to eq "2016-04-15T23:17:31.6+09:00" }
  end

  describe '.parse_latitude' do
    it { expect(parser.parse_latitude("32°51.5′N")).to eq 32.85138888888889 }
    it { expect(parser.parse_latitude("32°51.5′S")).to eq -32.85138888888889 }
  end

  describe '.parse_longitude' do
    it { expect(parser.parse_longitude('130°52.4′E')).to eq 130.86777777777777 }
    it { expect(parser.parse_longitude('130°52.4′W')).to eq -130.86777777777777 }
  end
end