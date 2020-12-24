#!/usr/bin/env node
const fs = require('fs');
const path = require('path');
const moment = require('moment');
PDFParser = require("pdf2json")

console.log('Extracting Markdown from .pdf files in directory');
let inputFolderPath = "./";
let outputFolderPath = "./../metadata/pdf";

const getAllFiles = (dirPath, arrayOfFiles) => {
  const files = fs.readdirSync(dirPath);
  arrayOfFiles = arrayOfFiles || []
  files.forEach(file => {
    if (fs.statSync(dirPath + "/" + file).isDirectory()) {
      arrayOfFiles = getAllFiles(dirPath + "/" + file, arrayOfFiles)
    } else {
      arrayOfFiles.push(path.join(dirPath, "/", file))
    }
  })
  return arrayOfFiles
}

// Read all the files
const files = fs.readdirSync(inputFolderPath);
let arrayOfFiles = [];
files.forEach(file => {
    if (fs.statSync(inputFolderPath + "/" + file).isDirectory()) {
      arrayOfFiles = getAllFiles(inputFolderPath + "/" + file, arrayOfFiles)
    } else {
      arrayOfFiles.push(path.join(inputFolderPath, "/", file))
    }
});

let guidanceFiles = arrayOfFiles.filter((file) => {
  if (file.match(/.pdf$/i)) {
  return file.includes('guidance-');
  }
  return false;
});
let checklistFiles = arrayOfFiles.filter((file) => {
  if (file.match(/.pdf$/i)) {
  return file.includes('checklist-');
  }
  return false;
});
checklistFiles.forEach(checklistFile => {
  // Create a pdf parser.
  let pdfParser = new PDFParser(this,1);
  // Load the file.
  pdfParser.loadPDF(`${inputFolderPath}/${checklistFile}`);
  pdfParser.on("pdfParser_dataError", errData => console.error(errData.parserError) );
  pdfParser.on("pdfParser_dataReady", pdfData => {
    // console.log(pdfData)
    // Read file contents and build plain text file as markdown.
    // Pass the file a custom formatter for the raw text.
    let markdownDoc = getMarkdown({formatter: formatterGuidance, pdfParser});
    let markdownFileName = checklistFile.replace(/.pdf/i, '.md');
    // console.log(markdownFileName);
    fs.writeFile(`${outputFolderPath}/${markdownFileName}`, markdownDoc, err => {if (err) console.error(err); else console.log('file created.');});
    return;
  });
})

console.log(guidanceFiles.length); // 569 files
guidanceFiles = guidanceFiles.slice(551,600);
// Last processed 11/25-2020, need to review the output.

// @TODO Make the batch formatting smarter.
// Spinning out too many processing requests at once hangs script.
const formatterGuidance = (text) => {
  text = text.replace(//g, "▢");
  return text;
}

const historicalConversions = () => {
  // archivalFolder, files saved as naming convention eg. guidance-transit-rail--ar.v1.7.pdf
  // or guidance-file--en.2020-07-02.pdf
  // host these files in folder called 'archive'
  // move archived files, renamed, to the archive folder.
  // process these the same way as the current files.
}

const automation = () => {
  // Since the files won't change, we can store a setting file with the date last updated for the md files, or detect it.
  // If it's in text, it may be easier to read and refer to.
  // We can do batches automatically and store.
  // This needs a function script & a github action.
  // Before we do that, we need better batching & also to test the processing on our server.
}

const buildMetadata = () => {
  // Currently we have document information from the pdf
  // We can see the publish date easily in the markdown, and also check the differences
  // It could be ideal if the PDF files have the right version & publish date, as well as canonical paths
  // We could augment the .md file with additional metadata, in the header or in a final section at the end, or in another file
  // called filename.meta.md or filename.meta.json

}

guidanceFiles.forEach(checklistFile => {
  // Create a pdf parser.
  let pdfParser = new PDFParser(this,1);
  // Load the file.
  pdfParser.loadPDF(`${inputFolderPath}/${checklistFile}`);
  pdfParser.on("pdfParser_dataError", errData => console.error(errData.parserError) );
  pdfParser.on("pdfParser_dataReady", pdfData => {
    // Read file contents and build plain text file as markdown.
    // Pass the file a custom formatter for the raw text.
    let markdownDoc = getMarkdown({formatter: formatterGuidance, pdfParser});
    let markdownFileName = checklistFile.replace(/.pdf/i, '.md');
    fs.writeFile(`${outputFolderPath}/${markdownFileName}`, markdownDoc, err => {if (err) console.error(err); else console.log('file created.');});
    return;
  });
})

const createSideBySideCsv = () => {
  // same file name
  // get text
  // split by '.'
  // create arrays
    // file name
        // lang
  // read arrays
  // CSV header, language
  // save each key in all languages as a field
  // handle fields
  // save file as csv
}

const getMarkdown = ({formatter = null, pdfParser}) => {
  // Process date
  let createdDateString = pdfParser.PDFJS.documentInfo.CreationDate;
  let modDateString = pdfParser.PDFJS.documentInfo.CreationDate;
  let createdDate = createdDateString.replace('D:', '').substring(0,14);
  let modDate = createdDateString.replace('D:', '').substring(0,14);
  let createdDateFormatted = moment(createdDate, "YYYYMMDDHHmmSS");
  let modDateFormatted = moment(createdDate, "YYYYMMDDHHmmSS");

  // Create a plain text file as markdown, with frontmatter attributes derived from this file.
  let doc = ['---'];
  Object.keys(pdfParser.PDFJS.documentInfo).map(item => {
      doc.push(`${item}: ${pdfParser.PDFJS.documentInfo[item]}`)
  });

  doc.push(`date_created: ${createdDateFormatted}`);
  doc.push(`date_modified: ${modDateFormatted}`);
  doc.push('---');

  let rawTextParsed = pdfParser.getRawTextContent();

  // Transformations
  if (formatter !== null) {
    try {
      formatter(rawTextParsed);
    } catch (error) {
      console.error('formatter not fonud');
    }
  }

  doc.push(rawTextParsed);
  let markdownDoc = doc.join('\n');
  return markdownDoc;
}
