package migrations

import (
	"encoding/json"
	"fmt"
	"io"
	"log"
	"os"

	"github.com/pocketbase/pocketbase/core"
	m "github.com/pocketbase/pocketbase/migrations"
)

func init() {
	m.Register(func(app core.App) error {
		seedInitialMeasurements(app)

		return nil
	}, func(app core.App) error {
		// add down queries...

		return nil
	})
}

func seedInitialMeasurements(app core.App) error {
	measurements, err := app.FindCollectionByNameOrId("measurements")
	if err != nil {
		return err
	}

	// Check if data has already been seeded
	totalMeasurements, err := app.CountRecords(measurements)
	if err != nil {
		return err
	}

	// Only seed if no measurements exist
	if totalMeasurements == 0 {
		// Read measurements from JSON file
		jsonFile, err := os.Open("./migrations/seedData/measurements.json")
		if err != nil {
			log.Fatalf("failed to open measurements.json: %v", err)
			return fmt.Errorf("failed to open measurements.json: %w", err)
		}
		defer jsonFile.Close()

		byteValue, err := io.ReadAll(jsonFile)
		if err != nil {
			log.Fatalf("failed to read measurements.json: %v", err)
			return fmt.Errorf("failed to read measurements.json: %w", err)
		}

		var measurementsData []map[string]string
		if err := json.Unmarshal(byteValue, &measurementsData); err != nil {
			log.Fatalf("failed to unmarshal measurements data: %v", err)
			return fmt.Errorf("failed to unmarshal measurements data: %w", err)
		}

		// Create records for each measurement
		for _, m := range measurementsData {
			record := core.NewRecord(measurements)
			record.Set("name", m["name"])
			record.Set("abbreviation", m["abbreviation"])
			record.Set("measurement_type", m["measurement_type"])

			// Save the record
			if err := app.Save(record); err != nil {
				log.Fatalf("failed to save measurement %s: %v", m["name"], err)
				return fmt.Errorf("failed to save measurement %s: %w", m["name"], err)
			}
		}

		log.Println("Successfully seeded", len(measurementsData), "measurements")
	}

	return nil
}
