COPY INTO {{ params.database }}.{{ params.schema }}.{{ params.table }} (RAW_DATA)
FROM @{{ params.database }}.{{ params.schema }}.{{ params.stage }}
FILE_FORMAT = (TYPE = 'PARQUET')
PURGE = FALSE -- don't delete S3 files until you're sure
ON_ERROR = 'SKIP_FILE';