defmodule Cocu.Repo.Migrations.AddProjectRateTrigger do
  use Ecto.Migration

  def change do
    execute """
    CREATE OR REPLACE FUNCTION update_project_rate()
    RETURNS trigger AS $$
    BEGIN
      IF (TG_OP = 'INSERT') THEN
        IF (NEW.positive) THEN
          UPDATE project SET karma = karma + 1 WHERE id = NEW.project_id;
          RETURN NEW;
        ELSE
          UPDATE project SET karma = karma - 1 WHERE id = NEW.project_id;
          RETURN NEW;
        END IF;
      RETURN NULL;

      ELSIF (TG_OP = 'UPDATE') THEN
        IF (NEW.positive) THEN
          UPDATE project SET karma = karma + 2 WHERE id = NEW.project_id;
          RETURN NEW;
        ELSE
          UPDATE project SET karma = karma - 2 WHERE id = NEW.project_id;
          RETURN NEW;
        END IF;
      RETURN NULL;

      ELSIF (TG_OP = 'DELETE') THEN
        IF (OLD.positive) THEN
          UPDATE project SET karma = karma - 1 WHERE id = OLD.project_id;
          RETURN OLD;
        ELSE
          UPDATE project SET karma = karma + 1 WHERE id = OLD.project_id;
          RETURN OLD;
        END IF;
      RETURN NULL;
      END IF;

    END;
    $$ LANGUAGE plpgsql;
    """

    execute "DROP TRIGGER IF EXISTS update_project_rate_trg ON vote;"
    execute """
    CREATE TRIGGER update_project_rate_trg
    AFTER INSERT OR UPDATE OR DELETE
    ON vote
    FOR EACH ROW
    EXECUTE PROCEDURE update_project_rate();
    """
  end
end
