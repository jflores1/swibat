module ContentCalendarHelper
	def content_calendar(date = Date.today, &block)
		ContentCalendar.new(self, date, block).table
	end

	class ContentCalendar < Struct.new(:view, :date, :callback)
		delegate :content_tag, to: :view

		HEADER = %w[January February March April May June July August September October November December]
		START_MONTH = Date.today.month

		def table
			content_tag :table, class: "content-calendar" do
				header + unit_title_row
			end
		end

		def header
			content_tag :thead do
				content_tag :tr do
					leading_header_cell + month_header
				end
			end
		end

		def leading_header_cell(title = nil)
			content_tag :th
		end

		def month_header
			HEADER.map {|month| content_tag :th, month}.join.html_safe
		end

		def unit_title_row
			months.map do |month|
				content_tag :tr do
					month.map { |cell| cell(content)}.join.html_safe
				end
			end.join.html_safe
		end

		def cell(content)
			content_tag :td, view_capture(content, &callback)
		end

		def months
			first = date.beginning_of_month
			last = date.end_of_quarter
			(first..last).to_a.in_groups_of(13)
		end
		
		
	end


end