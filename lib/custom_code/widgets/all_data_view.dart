// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/supabase/supabase.dart';
import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:text_search/text_search.dart';
import '/utils/components/tasks_row/tasks_row_widget.dart';

class AllDataView extends StatefulWidget {
  const AllDataView({
    super.key,
    this.width,
    this.height,
    this.data,
  });

  final double? width;
  final double? height;
  final List<SELECTPPIRFormsByAssigneeAndTaskStatusRow>? data;

  @override
  State<AllDataView> createState() => _AllDataViewState();
}

class _AllDataViewState extends State<AllDataView> {
  int _currentPage = 1;
  int _pageSize = 10;
  String _searchQuery = '';
  List<SELECTPPIRFormsByAssigneeAndTaskStatusRow> _searchResults = [];

  List<SELECTPPIRFormsByAssigneeAndTaskStatusRow> get _paginatedData {
    final data = _searchQuery.isEmpty ? widget.data! : _searchResults;
    final startIndex = (_currentPage - 1) * _pageSize;
    final endIndex = startIndex + _pageSize;
    return data.sublist(startIndex, endIndex.clamp(0, data.length));
  }

  void _performSearch(String query) {
    setState(() {
      _searchQuery = query;
      _currentPage = 1;
      if (query.isEmpty) {
        _searchResults = [];
      } else {
        final textSearch = TextSearch(
          widget.data!
              .map((task) => TextSearchItem(task, [
                    TextSearchItemTerm(task.ppirFarmername ?? ''),
                    TextSearchItemTerm(task.ppirInsuranceid ?? ''),
                    TextSearchItemTerm(task.ppirAssignmentid ?? ''),
                    TextSearchItemTerm(task.ppirAddress ?? ''),
                  ]))
              .toList(),
        );
        _searchResults =
            textSearch.search(query).map((result) => result.object).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _performSearch,
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: widget.data != null && widget.data!.isNotEmpty
                ? Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: _paginatedData.length,
                          itemBuilder: (context, index) {
                            final task = _paginatedData[index];
                            return TasksRowWidget(
                              farmerName: task.ppirFarmername ?? '',
                              insuranceId: task.ppirInsuranceid ?? '',
                              assignmentId: task.ppirAssignmentid ?? '',
                              ppirAddress: task.ppirAddress ?? '',
                              taskStatus: task.status ?? '',
                              taskId: task.taskId ?? '',
                              timeAccess: task.ppirUpdatedAt ?? '',
                            );
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: _currentPage > 1
                                ? () {
                                    setState(() {
                                      _currentPage--;
                                    });
                                  }
                                : null,
                          ),
                          Text('Page $_currentPage'),
                          IconButton(
                            icon: Icon(Icons.arrow_forward),
                            onPressed: _currentPage <
                                    ((_searchQuery.isEmpty
                                                    ? widget.data!
                                                    : _searchResults)
                                                .length /
                                            _pageSize)
                                        .ceil()
                                ? () {
                                    setState(() {
                                      _currentPage++;
                                    });
                                  }
                                : null,
                          ),
                        ],
                      ),
                    ],
                  )
                : Center(
                    child: Text('No data available'),
                  ),
          ),
        ],
      ),
    );
  }
}
