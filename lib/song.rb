class Song

  attr_accessor :name, :album, :id

  def initialize(name:, album:, id: nil)
    @name = name
    @album = album
    @id = id
  end

  def self.create_table
    sql =  <<-SQL
      CREATE TABLE IF NOT EXISTS songs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        album TEXT
      )
      SQL
    DB[:conn].execute(sql)
  end 

  def save
    sql = <<-SQL 
      INSERT INTO songs (name, album)
      VALUES (?, ?)
    SQL

      # inserts the song.
    DB[:conn].execute(sql, self.name, self.album)

    # gets the song ID from the database and save it to the Ruby instance.
    self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM songs")[0][0]

    # returns the Ruby instance.
    self
  end

  # cretaes an object and then saves a record representing that object.
  def self.create(name:, album:)
    song = Song.new(name: name, album: album)
    song.save
  end
end
