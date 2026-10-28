package com.certifind.config;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

@Component
public class ReferenceDataInitializer {

    private final JdbcTemplate jdbcTemplate;

    public ReferenceDataInitializer(DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
    }

    @jakarta.annotation.PostConstruct
    public void updateItalianEaSectorNames() {
        jdbcTemplate.execute("""
                ALTER TABLE ea_sector ADD COLUMN IF NOT EXISTS name_it VARCHAR(200)
                """);
        jdbcTemplate.update("""
                UPDATE ea_sector
                SET name_it = CASE code
                    WHEN 1 THEN 'Agricoltura e pesca'
                    WHEN 2 THEN 'Attività estrattive'
                    WHEN 3 THEN 'Prodotti alimentari, bevande e tabacco'
                    WHEN 4 THEN 'Tessili e prodotti tessili'
                    WHEN 5 THEN 'Pelli e prodotti in pelle'
                    WHEN 6 THEN 'Legno e prodotti in legno'
                    WHEN 7 THEN 'Pasta di legno, carta e prodotti di carta'
                    WHEN 8 THEN 'Case editrici'
                    WHEN 9 THEN 'Stampa'
                    WHEN 10 THEN 'Prodotti petroliferi raffinati'
                    WHEN 11 THEN 'Combustibile nucleare'
                    WHEN 12 THEN 'Prodotti chimici'
                    WHEN 13 THEN 'Prodotti farmaceutici'
                    WHEN 14 THEN 'Gomma e materie plastiche'
                    WHEN 15 THEN 'Prodotti minerali non metalliferi'
                    WHEN 16 THEN 'Calcestruzzo, cemento, calce e gesso'
                    WHEN 17 THEN 'Metalli di base e prodotti in metallo'
                    WHEN 18 THEN 'Macchinari e apparecchiature'
                    WHEN 19 THEN 'Apparecchiature elettriche e ottiche'
                    WHEN 20 THEN 'Cantieristica navale'
                    WHEN 21 THEN 'Aerospaziale'
                    WHEN 22 THEN 'Altri mezzi di trasporto'
                    WHEN 23 THEN 'Manifatturiero non classificato altrove'
                    WHEN 24 THEN 'Riciclaggio'
                    WHEN 25 THEN 'Fornitura di energia elettrica'
                    WHEN 26 THEN 'Fornitura di gas'
                    WHEN 27 THEN 'Fornitura di acqua'
                    WHEN 28 THEN 'Costruzioni'
                    WHEN 29 THEN 'Commercio all’ingrosso e al dettaglio'
                    WHEN 30 THEN 'Alberghi e ristoranti'
                    WHEN 31 THEN 'Trasporti, magazzinaggio e comunicazioni'
                    WHEN 32 THEN 'Intermediazione finanziaria, immobili e noleggio'
                    WHEN 33 THEN 'Tecnologie dell’informazione'
                    WHEN 34 THEN 'Servizi di ingegneria'
                    WHEN 35 THEN 'Altri servizi'
                    WHEN 36 THEN 'Amministrazione pubblica'
                    WHEN 37 THEN 'Istruzione'
                    WHEN 38 THEN 'Sanità e assistenza sociale'
                    WHEN 39 THEN 'Altri servizi sociali'
                END
                WHERE code BETWEEN 1 AND 39
                """);
    }
}
