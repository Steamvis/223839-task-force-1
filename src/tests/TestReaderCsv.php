<?php

namespace src\tests;

use Logic\FileSystem\managers\Readers\ReaderCSV;

class TestReaderCsv
{
    protected string $dir = 'test.csv';

    public function testOpenFile() : bool
    {
        $reader = new ReaderCSV();
        $filePath = $this->dir;
        return assert($reader->openFile($filePath), 'Could not open file');
    }
}
