module Kumamoto
  module Earthquake
    class Client

      def driver
        @driver ||= ::Kumamoto::CapybaraClient.new
      end

      def parser
        @parser ||= ::Kumamoto::Earthquake::Epicenter::Parser.new
      end

      def start(from_days, to_days)
        from_days.downto(to_days) do |i|
          from = i.days.ago.beginning_of_day
          to = from.end_of_day
          items = scrape(from, to)

          filename = Kumamoto.config.resource_path.join('earthquake', from.strftime('%Y'), from.strftime('%Y_%m_%d') + '.json')
          File.open(filename, "w") do |file|
            data = {created_at: Time.now.iso8601(1), size: items.size}
            data[:items] = items.map(&:serializable_hash) if items.any?
            file.write JSON.pretty_generate(data)
          end
        end
      end

      def scrape(from, to)
        stack = [[from, to]]
        items = []
        while stack.size > 0
          from, to = stack.pop
          puts "#{from} - #{to}"
          case scrape_epicenter_page(from, to)
          when :success
            items = items + parse_epicenter_page(driver.page)
          when :limited
            stack = stack + split_time_range(from, to)
          end
          sleep(3)
        end
        items
      end

      # @example
      #   split_time_range(Time.parse(2016-04-19 00:00), Time.parse(2016-04-19 23:59))
      #   #  => [ [2016-04-19 00:00, 2016-04-19 11:59], [2016-04-19 12:00 2016-04-19 23:59] ]
      def split_time_range(from, to)
        diff = to.end_of_minute - from.beginning_of_minute
        span = (diff / 2).round

        a1 = (from + span - 1.minutes).end_of_minute
        a2 = (a1 + 1.minutes).beginning_of_minute

        [
          [from, a1],
          [a2, to]
        ]
      end

      def parse_epicenter_page(page)
        rows = []
        page.find('table#SeisList').tap do |table|
          table.all('tr').each_with_index do |tr, i|
            if i == 0
              parser.parse_header(tr.all('th').map {|th| th.text })
              next
            end

            id = tr['onclick']
            rows << parser.parse_row(id, tr.all('td').map {|td| td.text })
          end
        end
        rows
      end

      def scrape_epicenter_page(from, to)
        driver.scrape do |driver|
          driver.page.visit 'http://www.data.jma.go.jp/svd/eqdb/data/shindo/index.php'
          driver.page.find('input.ymdF').set(from.strftime('%Y/%m/%d'))
          driver.page.find('input.hmsF').set(from.strftime('%H:%M'))
          driver.page.find('input.ymdT').set(to.strftime('%Y/%m/%d'))
          driver.page.find('input.hmsT').set(to.strftime('%H:%M'))
          driver.page.find('select#Sort')
          driver.page.select '発生日時の古い順', from: 'Sort'
          driver.page.click_button '地震を検索'
          driver.wait_for('#FieldRes')
        end

        text = driver.page.find('#FieldRes > ul > li').text.tapp
        if text.include?("で表示")
          :success
        elsif text.include?("ありませんでした")
          :not_found
        elsif text.include?("上限を超えました")
          :limited
        else
          :error
        end
      end

    end
  end
end