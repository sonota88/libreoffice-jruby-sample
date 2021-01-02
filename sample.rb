# coding: utf-8

# ライブラリをロード
require_relative "libo_calc"

def main 
  Calc.open("sample.fods") do |doc|
    # シートの一覧を取得
    sheets = doc.get_sheets()
    p sheets

    # シートをイテレート
    sheets.each_with_index do |sheet, i|
      puts "----------------"
      puts "#{i}: " + sheet.name
      # col, row / 文字列でセルの内容を取得
      puts "(0, 0) => " + sheet.get(0, 0)
      # セルに文字列をセット
      sheet.set(0, 0, "(0, 0) 日本語テキスト #{Time.now}")
      puts "(0, 0) => " + sheet.get(0, 0)
    end

    # 名前でシートを取得
    sheet = doc.get_sheet_by_name("Sheet1")

    puts "----------------"
    puts "(1, 1) => " + sheet.get(1, 1)
    sheet.set(1, 1, "(1, 1) #{ Time.now }")
    puts "(1, 1) => " + sheet.get(1, 1)

    puts "----------------"
    count = sheet.get(1, 3).to_i
    count = 0 unless count # 初回の初期化

    sheet.set(1, 3, count + 1)
    puts "count => #{ sheet.get(1, 3) }"

    # 上書き保存
    doc.save()
  end
end

main
