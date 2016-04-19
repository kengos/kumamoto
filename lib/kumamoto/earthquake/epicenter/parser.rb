module Kumamoto
  module Earthquake
    module Epicenter
      class Parser
        HEADER_FIELDS = {
          "地震の発生日時" => :occured_at,
          "震央地名" => :name,
          "緯度" => :latitude,
          "経度" => :longitude,
          "深さ" => :depth,
          "Ｍ" => :magnitude,
          "最大震度" => :japanese_scale
        }.freeze
        DATA_TIME_ZONE = "Asia/Tokyo".freeze
        LATITUDE_REGEXP = /(\d+)°(\d+)\.(\d+)′(N|S)/.freeze
        LONGITUDE_REGEXP = /(\d+)°(\d+)\.(\d+)′(E|W)/.freeze
        ID_REGEXP = /ID=(\d+)/.freeze

        attr_accessor :header_map

        def parse_header(headers)
          @header_map = {}.tap do |header_map|
            headers.each_with_index {|col, index| header_map[index] = HEADER_FIELDS[col] if HEADER_FIELDS.key?(col) }
          end
        end

        def parse_row(id, row)
          attributes = {}.tap do |attributes|
            attributes[:id] = id
            attributes[:created_at] = Time.now
            self.header_map.each do |index, attribute|
              attributes[attribute] = row.fetch(index, nil)
            end
          end
          build(attributes)
        end

        def build(attributes)
          Model.new.tap do |model|
            model.id = self.parse_id(attributes[:id])
            model.occured_at = self.parse_occured_at(attributes[:occured_at])
            model.name = attributes[:name]
            model.latitude = self.parse_latitude(attributes[:latitude])
            model.longitude = self.parse_longitude(attributes[:longitude])
            model.depth = attributes[:depth]
            model.magnitude = self.parse_magnitude(attributes[:magnitude])
            model.japanese_scale = self.parse_japanese_scale(attributes[:japanese_scale])
          end
        end

        def parse_id(value)
          value.match(ID_REGEXP)[1].to_i
        end

        def parse_latitude(value)
          matcher = value.match(LATITUDE_REGEXP)
          return nil if matcher.size != 5
          _value = matcher[1].to_f + (matcher[2].to_f / 60) + (matcher[3].to_f / 3_600)
          matcher[4] == 'N' ? _value : _value * (-1)
        end

        def parse_longitude(value)
          matcher = value.match(LONGITUDE_REGEXP)
          return nil if matcher.size != 5
          _value = matcher[1].to_f + (matcher[2].to_f / 60) + (matcher[3].to_f / 3_600)
          matcher[4] == 'E' ? _value : _value * (-1)
        end

        def parse_occured_at(value)
          _value = nil
          Time.zone.tap do |current_zone|
            begin
              Time.zone = DATA_TIME_ZONE
              _value = Time.zone.parse(value) rescue nil
            ensure
              Time.zone = current_zone
            end
          end
          _value
        end

        def parse_magnitude(value)
          return nil unless value
          Float(value.delete('Ｍ'))
        end

        def parse_japanese_scale(value)
          return nil unless value
          value.tr('弱強１２３４５６７', '-+1234567')
        end
      end
    end
  end
end