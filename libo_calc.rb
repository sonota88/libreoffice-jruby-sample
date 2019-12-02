# coding: utf-8

$CLASSPATH << "/usr/lib/libreoffice/program/classes/juh.jar"
$CLASSPATH << "/usr/lib/libreoffice/program/classes/ridl.jar"
$CLASSPATH << "/usr/share/libreoffice/program/classes/unoil.jar"

require "java"

java_import com.sun.star.uno.UnoRuntime

class Sheet
  attr_reader :name

  def initialize(sheet, name)
    @sheet = sheet
    @name = name
  end

  def get(ci, ri)
    cell = @sheet.getCellByPosition(ci, ri)
    cell.getFormula().to_s
  end

  def set(ci, ri, val)
    cell = @sheet.getCellByPosition(ci, ri)
    cell.setFormula(val.to_s)
  end
end

class CalcDocument
  def initialize(component)
    @component = component

    @doc = UnoRuntime.queryInterface(
      Java::ComSunStarSheet::XSpreadsheetDocument.java_class,
      @component
    )
  end

  def get_sheets
    sheets = []
    sheetNames = @doc.getSheets().getElementNames()

    (0...sheetNames.size).each do |i|
      sheetName = sheetNames[i]
      sheet = get_sheet_by_index(i)
      sheets << Sheet.new(sheet, sheetName)
    end

    sheets
  end

  def get_sheet_by_index(index)
    sheets = @doc.getSheets()

    indexAccess = UnoRuntime.queryInterface(
      Java::ComSunStarContainer::XIndexAccess.java_class,
      sheets
    )

    UnoRuntime.queryInterface(
      Java::ComSunStarSheet::XSpreadsheet.java_class,
      indexAccess.getByIndex(index)
    )
  end

  def get_sheet_by_name(name)
    sheets = @doc.getSheets()
    sheet_names = sheets.getElementNames()
    target_index = nil
    sheet_name = nil

    (0...sheet_names.size).each do |si|
      sheet_name = sheet_names[si]
      if sheet_name == name
        target_index = si
        break
      end
    end

    sheet = get_sheet_by_index(target_index)
    return Sheet.new(sheet, sheet_name)
  end

  def save
    storable = UnoRuntime.queryInterface(
      Java::ComSunStarFrame::XStorable.java_class,
      @component
    )
    storable.store()
  end

  def close
    closable = UnoRuntime.queryInterface(
      Java::ComSunStarUtil::XCloseable.java_class,
      @component
    )
    closable.close(true)
  end
end

module Calc
  def self.open(path)
    context = Java::ComSunStarCompHelper::Bootstrap.bootstrap()

    mcf = context.getServiceManager()

    desktop = mcf.createInstanceWithContext(
        "com.sun.star.frame.Desktop",
        context
    )

    componentLoader = UnoRuntime.queryInterface(
      Java::ComSunStarFrame::XComponentLoader.java_class,
      desktop
    )

    # GUI表示なし
    args = [arg("Hidden", true)]

    fileUrl = "file://" + File.expand_path(path)

    component = componentLoader.loadComponentFromURL(
      fileUrl, "_blank", 0, args
    )

    begin
      doc = CalcDocument.new(component)
      yield doc
    ensure
      doc.close if doc
    end
  end

  def self.arg(name, value)
    arg = Java::ComSunStarBeans::PropertyValue.new
    arg.Name = name
    arg.Value = value
    arg
  end
end
