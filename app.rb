require "sinatra"
require_relative "libo_calc"

post "/calc" do
  file = params["file"]
  sheet_name = params["sheet"]

  data = {}

  Calc.open(file) do |doc|
    sheet = doc.get_sheet_by_name(sheet_name)
    case params["command"]
    when "cell_get"
      data = cell_get(sheet, params)
    when "cell_set"
      cell_set(sheet, params)
      doc.save()
    when "dump"
      data = dump(sheet)
    else
      raise "unsupported command"
    end
  end

  content_type :json
  JSON.pretty_generate(data)
end

def cell_get(sheet, params)
  row = params["row"].to_i
  col = params["col"].to_i
  val = sheet.get(col, row)
  { val: val }
end

def cell_set(sheet, params)
  row = params["row"].to_i
  col = params["col"].to_i
  val = params["val"]
  sheet.set(col, row, val)
  {}
end

def unescape_formula(formula)
  if formula.start_with?("'")
    # https://wiki.documentfoundation.org/EscapingCharacters#Entering_a_single_quotation_mark_as_the_first_character_of_a_formula
    formula[1..-1]
  else
    formula
  end
end

def dump(sheet)
  rows =
    (0..(sheet.used_row_index_max)).map do |ri|
      (0..(sheet.used_column_index_max)).map do |ci|
        str = sheet.get(ci, ri)
        unescape_formula(str)
      end
    end

  { rows: rows }
end
