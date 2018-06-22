module Rubyplot
  class Figure
    include Rubyplot::Scripting::Plots
    include Rubyplot::GRWrapper::Tasks
    attr_accessor :title, :grid, :bounding_box
    def initialize
      @tasks = []
      @x_range = [0, 0]
      @y_range = [0, 0]
      @x_tick_count = 'default'
      @y_tick_count = 'default'
      @title = nil
      @title_shift = 0
      @drawn_flag = false
      @margin = 1 # Decides how many ticks above the higest value and
      @ticks_count = 'default'
      @drawing_size = 'default'
      @drawing_color = 'default'
      @grid = true
      @bounding_box = true
      @data_represent_flag = false
      @data_plot_flag =  false
    end

    def scatter(x_coordinates, y_coordinates, marker_color: 'default',
                marker_size: 'default', marker_type: 'default')
      if @data_represent_flag
        puts("\nThe figure is of data representation type")
        return
      else
        @data_plot_flag = true
      end

      x_coordinates.each do |i|
        if i < @x_range[0]
          @x_range[0] = i
        elsif i > @x_range[1]
          @x_range[1] = i
        end
      end
      y_coordinates.each do |i|
        if i < @y_range[0]
          @y_range[0] = i
        elsif i > @y_range[1]
          @y_range[1] = i
        end
      end
      @tasks.push(Scatter.new(x_coordinates, y_coordinates, marker_color: marker_color,
                  marker_size: marker_size, marker_type: marker_type))
    end

    def line(x_coordinates, y_coordinates, marker_color: 'default',
                marker_size: 'default', marker_type: 'default')
      if @data_represent_flag
        puts("\nThe figure is of data representation type")
        return
      else
        @data_plot_flag = true
      end
      x_coordinates.each do |i|
        if i < @x_range[0]
          @x_range[0] = i
        elsif i > @x_range[1]
          @x_range[1] = i
        end
      end
      y_coordinates.each do |i|
        if i < @y_range[0]
          @y_range[0] = i
        elsif i > @y_range[1]
          @y_range[1] = i
        end
      end
      @tasks.push(Line.new)
    end

    def bar()
      if @data_plot_flag
        puts("\nThe figure is of data plotting type")
        return
      else
        @data_represent_flag = true
      end

    end

    def set_axis # for internal use before drawing
      if @title != nil # GR framework requires axes to be set up before plotting
        @title_shift = 0.1 # only decrease the plotting area if title is present
      end
      SetViewPort.new(0.05, 0.99, 0.05, 0.99 - @title_shift).call
      SetWindow.new(@x_range[0], @x_range[1], @y_range[0],@y_range[1]).call
      # Make sure that window is set bigger than range figure out how to manage it
      SetTextAlign.new(2, 0).call
      SetTextFontPrec.new(103, 0).call
      SetCharHeight.new(0.012).call
      @y_tick_count = @y_range[1] - @y_range[0] if @y_tick_count == 'default'
      @x_tick_count = @x_range[1] - @x_range[0] if @x_tick_count == 'default'
      Axes.new((@x_range[1] - @x_range[0]).to_f / @x_tick_count,
                           (@y_range[1] - @y_range[0]).to_f / @y_tick_count,
                           @x_range[0], @y_range[0], 1, 1, 0.01).call
      Grid.new((@x_range[1] - @x_range[0]).to_f / @x_tick_count,
                          (@y_range[1] - @y_range[0]).to_f / @y_tick_count,
                          @x_range[0], @y_range[0], 1, 1).call
      if @title_shift != 0
        SetCharHeight.new(0.05).call
        Text.new(0.5, 0.9, @title).call
      end
    end

    def draw
      return if @drawn_flag
      @drawn_flag = true
      set_axis
    end



    def view
      draw
      @tasks.each do |task|
        task.call()
      end
      UpdateWs.new.call
      puts("\nPress any button to continue")
      gets
    end

    def save(file_name)
      BeginPrint.new(file_name).call
      draw
      @tasks.each do |task|
        task.call()
      end
      EndPrint.new.call
    end
  end
end

=begin
    class
      attr_accessor :title
      def initialize
        @tasks = []
        @title = nil
        @drawn_flag = false
      end

      def draw
        return if @drawn_flag
        @drawn_flag = true
      end

      def write(filename)
        draw
        GrBeginPrint.new(filename).call
        @tasks.each do |task|
          task.call()
        end
        GrEndPrint.new.call
      end

      def display
        draw
        @tasks.each do |task|
          task.call()
        end
        GrUpdateWs.new.call
        puts("\nPress any button to continue")
        gets
    end

=end