require 'pg'
require 'uri'

class Bookmark

  attr_reader :result

  def self.all
    if ENV['ENVIRONMENT'] == 'test'
      connection = PG.connect(dbname: 'bookmark_manager_test')
    else
      connection = PG.connect(dbname: 'bookmark_manager')
    end

    @result = connection.exec("SELECT * FROM bookmarks")
    return @result.to_a
  end

  def self.create(url:, title:)
    if ENV['ENVIRONMENT'] == 'test'
      connection = PG.connect(dbname: 'bookmark_manager_test')
    else
      connection = PG.connect(dbname: 'bookmark_manager')
    end

    connection.exec("INSERT INTO bookmarks (url, title) VALUES('#{url}', '#{title}')")
  end

  def self.unique?(url)
    if ENV['ENVIRONMENT'] == 'test'
      connection = PG.connect(dbname: 'bookmark_manager_test')
    else
      connection = PG.connect(dbname: 'bookmark_manager')
    end

    @result = connection.exec("SELECT * FROM bookmarks WHERE url LIKE '#{url}';")
    @result.to_a.length == 0
  end

  def self.is_url?(url)
    uri = URI.parse(url)
    uri.kind_of?(URI::HTTP) && uri.kind_of?(URI::HTTPS)
  end

  def self.delete_bookmarks(urls)
    if ENV['ENVIRONMENT'] == 'test'
      connection = PG.connect(dbname: 'bookmark_manager_test')
    else
      connection = PG.connect(dbname: 'bookmark_manager')
    end

    @result = connection.exec("DELETE FROM bookmarks WHERE url IN ('#{urls.join("','")}');")
    return @result
  end

  def self.update_bookmark(url)
    if ENV['ENVIRONMENT'] == 'test'
      connection = PG.connect(dbname: 'bookmark_manager_test')
    else
      connection = PG.connect(dbname: 'bookmark_manager')
    end

    @result = connection.exec("UPDATE bookmarks SET title = #{} WHERE url #{url};")
    return @result
  end
end
