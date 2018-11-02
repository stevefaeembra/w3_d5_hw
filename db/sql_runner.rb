require('pg')

class SqlRunner

  def self.run( sql, values = [] )
    begin
      db = PG.connect({ dbname: 'cinema', host: 'localhost' })
      db.prepare("query", sql)
      result = db.exec_prepared("query", values)
    ensure
      db.close() if db != nil
    end
    return result
  end

  def self.run_insert(sql, values = [])
    # like run, but returns the id of the first Hash
    # the insert sql MUST use 'returning' clause
    # so we can store it in the original object
    result = self.run(sql, values)
    result.first["id"].to_i
  end

end
