# coding: utf-8

require "json"

require "./libo_calc"

def empty_col?(col)
  col.nil? or col.empty?
end

def get_max_ri(rows)
  ri = rows.size
  while ri >= 0
    ri -= 1
    unless rows[ri].all? { |col| empty_col?(col) }
      break
    end
  end

  ri
end

def get_max_ci(rows)
  ci = rows.size
  while ci >= 0
    ci -= 1
    cols = rows.map { |cols| cols[ci] }
    unless cols.all? { |col| empty_col?(col) }
      break
    end
  end

  ci
end

def main(file, sheet_name)
  Calc.open(file) do |doc|
    sheet = doc.get_sheet_by_name(sheet_name)

    rows =
      (0...100).map do |ri|
        (0...100).map do |ci|
          sheet.get(ci, ri)
        end
      end

    max_ri = get_max_ri(rows)
    max_ci = get_max_ci(rows)

    rows_trimmed = rows.map { |cols| cols[0..max_ci] }[0..max_ri]

    rows_trimmed.each do |cols|
      puts JSON.generate(cols)
    end
  end
end

begin
  main(
    ARGV[0], # fods ファイル名
    ARGV[1]  # シート名
  )
ensure
  exit
end
