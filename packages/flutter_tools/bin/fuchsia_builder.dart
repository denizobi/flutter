// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';

import '../lib/src/base/context.dart';
import '../lib/src/base/logger.dart';
import '../lib/src/flx.dart';
import '../lib/src/globals.dart';

const String _kOptionSnapshotter = 'snapshotter-path';
const String _kOptionTarget = 'target';
const String _kOptionPackages = 'packages';
const String _kOptionOutput = 'output-file';
const String _kOptionSnapshot = 'snapshot';
const String _kOptionDepfile = 'depfile';
const String _kOptionWorking = 'working-dir';
const List<String> _kOptions = const <String>[
  _kOptionSnapshotter,
  _kOptionTarget,
  _kOptionPackages,
  _kOptionOutput,
  _kOptionSnapshot,
  _kOptionDepfile,
  _kOptionWorking,
];

Future<Null> main(List<String> args) async {
  context[Logger] = new StdoutLogger();
  final ArgParser parser = new ArgParser()
    ..addOption(_kOptionSnapshotter, help: 'The snapshotter executable')
    ..addOption(_kOptionTarget, help: 'The entry point into the app')
    ..addOption(_kOptionPackages, help: 'The .packages file')
    ..addOption(_kOptionOutput, help: 'The generated flx file')
    ..addOption(_kOptionSnapshot, help: 'The generated snapshot file')
    ..addOption(_kOptionDepfile, help: 'The generated dependency file')
    ..addOption(_kOptionWorking,
        help: 'The directory where to put temporary files');
  final ArgResults argResults = parser.parse(args);
  if (_kOptions.any((String option) => !argResults.options.contains(option))) {
    printError('Missing option! All options must be specified.');
    exit(1);
  }
  String outputPath = argResults[_kOptionOutput];
  final int result = await build(
    snapshotterPath: argResults[_kOptionSnapshotter],
    mainPath: argResults[_kOptionTarget],
    outputPath: outputPath,
    snapshotPath: argResults[_kOptionSnapshot],
    depfilePath: argResults[_kOptionDepfile],
    workingDirPath: argResults[_kOptionWorking],
    packagesPath: argResults[_kOptionPackages],
    includeRobotoFonts: true,
  );
  if (result != 0) {
    printError('Error building $outputPath: $result.');
  }
  exit(result);
}
