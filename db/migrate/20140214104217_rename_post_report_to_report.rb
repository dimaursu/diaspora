class RenamePostReportToReport < ActiveRecord::Migration
  def self.up
    rename_table :post_reports, :reports unless table_exists? :reports
  end
  def self.down
    rename_table :reports, :post_reports
  end
end
