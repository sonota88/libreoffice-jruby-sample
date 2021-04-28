# coding: utf-8

require "json"

require_relative "libo_calc"

def unescape_formula(formula)
  if formula.start_with?("'")
    # https://wiki.documentfoundation.org/EscapingCharacters#Entering_a_single_quotation_mark_as_the_first_character_of_a_formula
    formula[1..-1]
  else
    formula
  end
end

def main(file, sheet_name)
  Calc.open(file) do |doc|
    sheet = doc.get_sheet_by_name(sheet_name)

    rows =
      (0..(sheet.used_row_index_max)).map do |ri|
        (0..(sheet.used_column_index_max)).map do |ci|
          str = sheet.get(ci, ri)
          unescape_formula(str)
        end
      end

    rows.each do |cols|
      puts JSON.generate(cols)
    end
  end
end

main(
  ARGV[0], # fods ファイル名
  ARGV[1]  # シート名
)
