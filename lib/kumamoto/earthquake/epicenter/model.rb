module Kumamoto
  module Earthquake
    # http://www.data.jma.go.jp/svd/eqdb/data/shindo/index.php
    module Epicenter
      class Model
        include ::ActiveModel::Model
        include ::ActiveModel::Serialization

        attr_accessor :id, :name, :latitude, :longitude, :depth, :magnitude, :japanese_scale
        attr_writer :occured_at

        def occured_at
          @occured_at.try(:iso8601, 1)
        end

        def attributes
          instance_values
        end
      end
    end
  end
end