require "prawn"
require 'prawn-svg'
require "prawn/measurement_extensions"

require "./models/template"
require "./clients/noun_project_client"
require "./clients/twitter_client"

class Item < Prawn::Document
  AVAILABLE_FONTS = ["Abel", "AlegreyaSans", "Cantarell", "Cardo", "Cinzel", "Cuprum",
                     "DidactGothic", "JosefinSans", "K2D", "KumarOneOutline", "Niramit",
                     "OpenSans", "Oswald", "PT_Sans", "Slabo"]

  def initialize(opts)
    @template = Template.load(opts[:template])
    super page_size: @template.size, margin: [0,0,0,0]

    register_fonts
    font opts[:font]

    draw_design(opts)

    file_name        = opts[:file_name] || "item_#{Time.now.to_i}"
    render_file("exports/#{file_name}.ai")
  end

private

  def draw_design(opts)
    draw_text(opts[:text])
    draw_icon(opts[:icon])
    draw_tweet(opts[:tweet])
    draw_pattern(opts[:pattern])
    draw_nested_pattern(opts[:nested_pattern])
  end

  def draw_text(text)
    return if text.nil?
    text text,
         size: 30,
         align: :center,
         valign: :center,
         fill_color: "000000",
         mode: :fill_clip,
         fill: "000000"
  end

  def draw_icon(icon)
    return if icon.nil?
    NounProjectClient.new.find_icon(icon)
    svg IO.read("./icons/#{icon}.svg"),
                position: :center,
                vposition: :center,
                width: @template.size[0]/2.5
  end

  def draw_tweet(tweet)
    return if tweet.nil?

    svg IO.read("./icons/twitter.svg"),
                at: [15, @template.size[1] - 15],
                width: 15

    font "Cardo"
    text_box clean_text(tweet.text),
             size: 14,
             width: @template.size[0] * 0.75,
             height: @template.size[0] * 0.4,
             at: [@template.size[0] * 0.125, @template.size[1] * 0.6],
             mode: :fill_clip

   font "Oswald"
   text_box tweet.user.screen_name,
            at: [35, @template.size[1] - 12],
            size: 10,
            mode: :fill_clip

   text_box tweet.created_at.strftime("%B %e, %Y").upcase,
            at: [15, @template.size[1] - 32],
            size: 10,
            mode: :fill_clip

  end

  def draw_pattern(pattern)
    return if pattern.nil?
    apply_pattern_settings(pattern)

    if pattern[:type] == :triangle
      draw_triangle_pattern
    elsif pattern[:type] == :square
      draw_square_pattern
    end
  end

  def apply_pattern_settings(opts)
    @size_factor      = opts[:size_factor]  || 0.15 # what size will each object be, as a % of the width
    @fill_factor      = opts[:fill_factor]  || 0.25 # % change an object will be filled
    @omission_factor  = opts[:omission_factor]  || 0.25 # % change an object will be omitted
    @punch_factor     = opts[:punch_factor] || 0.25 # % change a non-filled items will be punched out

    @start_position   = [0,0]
  end

  def draw_triangle_pattern
    length = @template.size[0] * @size_factor
    height = Math.sqrt(3) / 2  * length

    rows    = (@template.size[0] / length).to_i + 1
    columns = (@template.size[1] / height).to_i + 1

    columns.times do |i|
      rows.times do
        pos_1 = [@start_position[0], @start_position[1]]
        pos_2 = [@start_position[0] + length / 2, @start_position[1] + height]
        pos_3 = [@start_position[0] + length, @start_position[1]]

        if @fill_factor > random_percentage
          if random_percentage > @omission_factor
            fill_polygon(pos_1, pos_2, pos_3)
          end
        else
          if @punch_factor > random_percentage
            line_width 0.01 # increase for demonstration
            stroke_color "ff0000"
          else
            line_width 0.14
            stroke_color "000000"
          end
          stroke_polygon(pos_1, pos_2, pos_3)
        end

        @start_position = [@start_position[0] + length, @start_position[1]]
      end
      @start_position = [0 - (i.even? ? length/2 : 0), @start_position[1] + height]
    end
  end

  def draw_square_pattern
    length = @template.size[0] * @size_factor
    height = length

    rows    = (@template.size[0] / length).to_i + 1
    columns = (@template.size[1] / height).to_i + 1

    columns.times do |i|
      rows.times do
        pos_1 = [@start_position[0], @start_position[1]]
        pos_2 = [@start_position[0], @start_position[1] + height]
        pos_3 = [@start_position[0] + length, @start_position[1] + height]
        pos_4 = [@start_position[0] + length, @start_position[1]]

        if @fill_factor > random_percentage
          if random_percentage > @omission_factor
            fill_polygon(pos_1, pos_2, pos_3, pos_4)
          end
        else
          if @punch_factor > random_percentage
            line_width 0.01 # increase for demonstration
            stroke_color "ff0000"
          else
            line_width 0.15
            stroke_color "000000"
          end
          stroke_polygon(pos_1, pos_2, pos_3, pos_4)
        end

        @start_position = [@start_position[0] + length, @start_position[1]]
      end
      @start_position = [0 - (i.even? ? length/2 : 0), @start_position[1] + height]
    end
  end


  def draw_nested_pattern(opts)
    return if opts.nil?
    nested_patterns = ["cube_1", "cube_2", "cube_3", "cube_4", "cube_5", "cube_6"]
    size_factor      = opts[:size_factor] || 0.15 # what size will each object be, as a % of the width

    length = @template.size[0] * size_factor
    height = length * 1.3249 #ratio of cube pattern

    start_position   = [0, 0 + height]

    rows    = (@template.size[0] / length).to_i + 1
    columns = (@template.size[1] / height).to_i + 1

    columns.times do |i|
      rows.times do
        svg IO.read("./nested_patterns/#{nested_patterns.sample}.svg"),
                    at: [start_position[0], start_position[1]],
                    width: length,
                    height: height

        start_position = [start_position[0] + length, start_position[1]]
      end
      start_position = [0, start_position[1] + height]
    end
  end

  def register_fonts
    font_families.update(
      Hash[ AVAILABLE_FONTS.collect { |f| [f, { normal: "./fonts/#{f}.ttf"}] } ]
    )
  end

  def clean_text(text)
    regex = /[\u{1f300}-\u{1f5ff}]|[\u{2500}-\u{2BEF}]|[\u{1f600}-\u{1f64f}]|[\u{2702}-\u{27b0}]/
    text.dup.force_encoding('utf-8').encode.gsub regex, ""
  end

  def random_percentage
    Random.new.rand(0.0..1.0)
  end
end
