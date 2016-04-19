require 'spec_helper'

RSpec.describe Kumamoto::Earthquake::Client do
  let(:client) { described_class.new }
  describe '#split_time_range' do
    let(:from) { Time.parse('2016-04-19').beginning_of_day }
    let(:to) { from.end_of_day }
    let(:split1) { client.split_time_range(from, to) }
    let(:split2) { client.split_time_range(split1[0][0], split1[0][1]) }
    let(:split2_1) { client.split_time_range(split2[0][0], split2[0][1]) }
    let(:split3) { client.split_time_range(split1[1][0], split1[1][1]) }
    it {
      expect(split1[0][0].strftime('%Y-%m-%d %H:%M')).to eq '2016-04-19 00:00'
      expect(split1[0][1].strftime('%Y-%m-%d %H:%M')).to eq '2016-04-19 11:59'
      expect(split1[1][0].strftime('%Y-%m-%d %H:%M')).to eq '2016-04-19 12:00'
      expect(split1[1][1].strftime('%Y-%m-%d %H:%M')).to eq '2016-04-19 23:59'
    }

    it {
      expect(split2[0][0].strftime('%Y-%m-%d %H:%M')).to eq '2016-04-19 00:00'
      expect(split2[0][1].strftime('%Y-%m-%d %H:%M')).to eq '2016-04-19 05:59'
      expect(split2[1][0].strftime('%Y-%m-%d %H:%M')).to eq '2016-04-19 06:00'
      expect(split2[1][1].strftime('%Y-%m-%d %H:%M')).to eq '2016-04-19 11:59'
    }

    it {
      expect(split2_1[0][0].strftime('%Y-%m-%d %H:%M')).to eq '2016-04-19 00:00'
      expect(split2_1[0][1].strftime('%Y-%m-%d %H:%M')).to eq '2016-04-19 02:59'
      expect(split2_1[1][0].strftime('%Y-%m-%d %H:%M')).to eq '2016-04-19 03:00'
      expect(split2_1[1][1].strftime('%Y-%m-%d %H:%M')).to eq '2016-04-19 05:59'
    }

    it {
      expect(split3[0][0].strftime('%Y-%m-%d %H:%M')).to eq '2016-04-19 12:00'
      expect(split3[0][1].strftime('%Y-%m-%d %H:%M')).to eq '2016-04-19 17:59'
      expect(split3[1][0].strftime('%Y-%m-%d %H:%M')).to eq '2016-04-19 18:00'
      expect(split3[1][1].strftime('%Y-%m-%d %H:%M')).to eq '2016-04-19 23:59'
    }
  end
end