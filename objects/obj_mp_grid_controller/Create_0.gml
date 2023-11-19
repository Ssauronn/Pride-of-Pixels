globalvar movementGrid, unitGridLocation, unitQueueTimer, unitQueueTimerStart, unitQueueForPathfindingList, unitQueueCount, unitQueueMax, selectedUnitsDefaultDirectionToFace;
movementGrid = mp_grid_create(0, 0, floor(room_width / 16), floor(room_width / 16), 16, 16);
unitGridLocation = noone;
unitQueueTimerStart = 1000000 / 60 * 2;
unitQueueTimer = unitQueueTimerStart;
unitQueueForPathfindingList = noone;
unitQueueCount = 0;
unitQueueMax = 100;
selectedUnitsDefaultDirectionToFace = -1;


